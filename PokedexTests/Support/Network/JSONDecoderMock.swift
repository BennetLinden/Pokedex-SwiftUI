//
//  JSONDecoderMock.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Foundation

final class JSONDecoderMock: JSONDecoder, @unchecked Sendable {
    private let onDecode: @Sendable () -> Void

    init(onDecode: @escaping @Sendable () -> Void) {
        self.onDecode = onDecode
        super.init()
    }

    override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        onDecode()
        return try super.decode(type, from: data)
    }
}
