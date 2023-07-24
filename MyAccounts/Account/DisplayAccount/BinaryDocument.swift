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

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct BinaryDocument: FileDocument {
    static var readableContentTypes = [UTType.data]
    var data: Data

    init(_ data: Data) {
        self.data = data
    }

    init(_ base64data: String?) throws {
        guard let base64data else {
            throw BinaryFileError.binaryFileError(
                "Can't init BinaryDocument when `base64data` is null!"
            )
        }
        if let data = Data(base64Encoded: base64data) {
            self.data = data
            return
        }
        throw BinaryFileError.binaryFileError(
            "Couldn't init file from base64 encoded data: \(base64data)"
        )
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = data
            return
        }
        throw BinaryFileError.binaryFileError(
            "Couldn't read file \(configuration.file.filename ?? "[couldn't get file name]")"
        )
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

enum BinaryFileError {
case binaryFileError(_ message: String)
}

extension BinaryFileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .binaryFileError(let message):
            return message
        }
    }
}
