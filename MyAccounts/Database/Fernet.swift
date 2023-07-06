// Copyright (C) 2023. Bohdan Kolvakh
// This file is part of MyAccounts.
// 
// MyAccounts is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Most of this code is copied from StackOverflow:
//  https://stackoverflow.com/a/68614588/11004423
//  https://stackoverflow.com/a/72799583/11004423
//  https://stackoverflow.com/a/62681784/11004423

import Foundation
import CommonCrypto

extension Data {
    init?(base64URL base64: String) {
        var base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        self.init(base64Encoded: base64)
    }

    static func secureRandom(ofSize size: Int) -> Data {
        var output = [UInt8](repeating: 0, count: size)
        // TODO: always test what was returned!
        _ = SecRandomCopyBytes(kSecRandomDefault, size, &output)
        return Data(output)
    }
}

func encryptFernet(data: Data, key: Data, iv: Data) -> Data {
    var encryptor: CCCryptorRef?
    defer {
        CCCryptorRelease(encryptor)
    }

    var key = Array(key)
    var iv = Array(iv)
    var plaintext = Array(data)

    CCCryptorCreate(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOperation(kCCOptionPKCS7Padding), &key, key.count, &iv, &encryptor)

    var outputBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(encryptor, plaintext.count, false))
    CCCryptorUpdate(encryptor, &plaintext, plaintext.count, &outputBytes, outputBytes.count, nil)

    var movedBytes = 0
    var finalBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(encryptor, 0, true))
    CCCryptorFinal(encryptor, &finalBytes, finalBytes.count, &movedBytes)

    return Data(outputBytes + finalBytes[0 ..< movedBytes])
}

func decryptFernet(ciphertext: Data, key: Data, iv: Data) -> Data {
    var decryptor: CCCryptorRef?

    defer {
        CCCryptorRelease(decryptor)
    }

    var key = Array(key)
    var iv = Array(iv)
    var ciphertext = Array(ciphertext)

    CCCryptorCreate(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), &key, key.count, &iv, &decryptor)

    var outputBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(decryptor, ciphertext.count, false))
    CCCryptorUpdate(decryptor, &ciphertext, ciphertext.count, &outputBytes, outputBytes.count, nil)

    var movedBytes = 0
    var finalBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(decryptor, 0, true))
    CCCryptorFinal(decryptor, &finalBytes, finalBytes.count, &movedBytes)

    return Data(outputBytes + finalBytes[0 ..< movedBytes])
}

func computeHMAC(_ data: Data, using key: Data) -> Data {
    var data = Array(data)
    var key = Array(key)
    var macOut = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), &key, key.count, &data, data.count, &macOut)
    return Data(macOut)
}

func verifyHMAC(_ mac: Data, authenticating data: Data, using key: Data) -> Bool {
    var data = Array(data)
    var key = Array(key)
    var macOut = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), &key, key.count, &data, data.count, &macOut)
    return Array(mac) == macOut
}

func pbkdf2(password: String, saltData: Data) -> Data? {
    guard let passwordData = password.data(using: .utf8) else { return nil }
    let keyByteCount = 32
    var derivedKeyData = Data(repeating: 0, count: keyByteCount)
    let derivedCount = derivedKeyData.count
    let derivationStatus: Int32 = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
        let keyBuffer: UnsafeMutablePointer<UInt8> =
            derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
        return saltData.withUnsafeBytes { saltBytes -> Int32 in
            let saltBuffer: UnsafePointer<UInt8> = saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                password,
                passwordData.count,
                saltBuffer,
                saltData.count,
                CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256),
                UInt32(100_000),
                keyBuffer,
                derivedCount)
        }
    }
    return derivationStatus == kCCSuccess ? derivedKeyData : nil
}
