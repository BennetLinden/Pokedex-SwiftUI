//
//  StringInterpolationExtensionsTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct StringInterpolationExtensionsTests {

    @Test func pokemonIdPadsToThreeDigits() {
        #expect("\(pokemonId: 1)" == "001")
        #expect("\(pokemonId: 25)" == "025")
        #expect("\(pokemonId: 151)" == "151")
    }

    @Test func optionalFallsBackToNil() {
        let missing: Int? = nil
        let present: Int? = 5
        #expect("\(missing)" == "nil")
        #expect("\(present)" == "5")
    }
}
