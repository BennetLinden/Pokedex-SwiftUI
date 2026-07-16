//
//  TestJSONLoader.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Foundation

enum TestJSONLoader {
    enum TestJSONLoaderError: Error, CustomStringConvertible {
        case resourceNotFound(String)

        var description: String {
            switch self {
            case let .resourceNotFound(name):
                "Missing JSON resource '\(name).json' in the test bundle."
            }
        }
    }

    /// Anchors `Bundle(for:)` to the test bundle (no SPM-style `Bundle.module` here).
    private final class BundleToken {}

    static func load(file: String) throws -> Data {
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: file, withExtension: "json") else {
            throw TestJSONLoaderError.resourceNotFound(file)
        }
        return try Data(contentsOf: url)
    }
}
