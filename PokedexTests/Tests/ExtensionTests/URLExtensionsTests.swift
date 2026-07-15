//
//  URLExtensionsTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct URLExtensionsTests {

    @Test func pokemonConstants() {
        #expect(URL.pokemonAPI.absoluteString == "https://pokeapi.co/api/")
        #expect(URL.pokemonImages.absoluteString.contains("PokeAPI/sprites"))
    }
}
