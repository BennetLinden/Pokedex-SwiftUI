//
//  JSONData.swift
//  PokedexTests
//
//  Loads raw JSON data for a named file from the test bundle. Decoding is left to
//  the caller (e.g. `JSONDecoder.default`).
//

import Foundation

enum JSONData {
    enum JSONDataError: Error, CustomStringConvertible {
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
            throw JSONDataError.resourceNotFound(file)
        }
        return try Data(contentsOf: url)
    }
}
