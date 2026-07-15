//
//  URLComponentsExtensionsTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct URLComponentsExtensionsTests {

    @Test func appendsPathComponents() throws {
        var components = try #require(URLComponents(string: "https://example.com/api"))
        components.append(path: "users/42")
        #expect(components.path == "/api/users/42")
    }

    @Test func appendEmptyPathIsNoOp() throws {
        var components = try #require(URLComponents(string: "https://example.com/api"))
        components.append(path: "")
        #expect(components.path == "/api")
    }
}
