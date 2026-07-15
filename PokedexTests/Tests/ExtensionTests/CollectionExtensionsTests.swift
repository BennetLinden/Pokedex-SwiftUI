//
//  CollectionExtensionsTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct CollectionExtensionsTests {

    @Test func isNotEmpty() {
        #expect([1, 2].isNotEmpty == true)
        #expect([Int]().isNotEmpty == false)
        #expect("".isNotEmpty == false)
    }
}
