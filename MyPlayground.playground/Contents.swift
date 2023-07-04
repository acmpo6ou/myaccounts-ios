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
        _ = SecRandomCopyBytes(kSecRandomDefault, size, &output)
        return Data(output)
    }
}

func encrypt(plaintext: Data, key: Data, iv: Data) -> Data {
    var encryptor: CCCryptorRef?
    defer {
        CCCryptorRelease(encryptor)
    }

    var key = Array(key)
    var iv = Array(iv)
    var plaintext = Array(plaintext)

    CCCryptorCreate(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOperation(kCCOptionPKCS7Padding), &key, key.count, &iv, &encryptor)

    var outputBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(encryptor, plaintext.count, false))
    CCCryptorUpdate(encryptor, &plaintext, plaintext.count, &outputBytes, outputBytes.count, nil)

    var movedBytes = 0
    var finalBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(encryptor, 0, true))
    CCCryptorFinal(encryptor, &finalBytes, finalBytes.count, &movedBytes)

    return Data(outputBytes + finalBytes[0 ..< movedBytes])
}

func decrypt(ciphertext: Data, key: Data, iv: Data) -> Data {
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

func pbkdf2(password: String, saltData: Data, keyByteCount: Int, prf: CCPseudoRandomAlgorithm, rounds: Int) -> Data? {
    guard let passwordData = password.data(using: .utf8) else { return nil }
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
                prf,
                UInt32(rounds),
                keyBuffer,
                derivedCount)
        }
    }
    return derivationStatus == kCCSuccess ? derivedKeyData : nil
}

guard let salt = Data(base64Encoded: "bd7XCr7MHx+zkjGJwYig1g==") else { fatalError() }
guard let fernetKey = pbkdf2(password: "password", saltData: salt, keyByteCount: 32, prf: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), rounds: 100_000) else { fatalError() }
print(fernetKey.base64EncodedString())

let signingKey  = fernetKey[0 ..< 16]
let cryptoKey   = fernetKey[16 ..< fernetKey.count]

// let fernetToken = Data(base64URL: "gAAAAABko-fciC5s33JXz4uShVkO40l3h3kLZViK4QeAnVl16WahW-Oy8KdxqBRwm3rjAPfsF4UFP6hlP_uYRcCQL5hFUjy2Gg==")!
// let version     = Data([fernetToken[0]])
// let timestamp   = fernetToken[1 ..< 9]
// var iv          = fernetToken[9 ..< 25]
// let ciphertext  = fernetToken[25 ..< fernetToken.count - 32]
// let hmac        = fernetToken[fernetToken.count - 32 ..< fernetToken.count]
//
// let plainText = decrypt(ciphertext: ciphertext, key: cryptoKey, iv: iv)
// print(plainText, String(data: plainText, encoding: .utf8) ?? "Non utf8")
// print(verifyHMAC(hmac, authenticating: version + timestamp + iv + ciphertext, using: signingKey))

 let plaintext = Data("Hello world!".utf8)
 let version: [UInt8] = [0x80]
 let timestamp: [UInt8] = {
    let timestamp = Int(Date().timeIntervalSince1970).bigEndian
    return withUnsafeBytes(of: timestamp, Array.init)
 }()
 let iv = Data.secureRandom(ofSize: kCCBlockSizeAES128)
 let ciphertext = encrypt(plaintext: plaintext, key: cryptoKey, iv: iv)
 let hmac = computeHMAC(version + timestamp + iv + ciphertext, using: signingKey)

 let fernetToken = (version + timestamp + iv + ciphertext + hmac).base64EncodedString()

 print("Fernet key: \(fernetKey)")
 print("Fernet token: \(fernetToken)")
