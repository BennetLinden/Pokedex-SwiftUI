//
//  PokemonDetailsDTODecodingTests.swift
//  PokedexTests
//
//  Exercises PokemonDetailsDTO's custom `init(from:)` — and, since sprites are
//  decoded nested within details, also covers PokemonSpritesDTO's decoder
//  (both the artwork-present and null-artwork branches).
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct PokemonDetailsDTODecodingTests {

    @Test func decodesCoreFieldsAndNestedTypes() throws {
        let data = try TestJSONLoader.load(file: "bulbasaur_details")
        let details = try JSONDecoder.default.decode(PokemonDetailsDTO.self, from: data)

        #expect(details.id == 1)
        #expect(details.name == "bulbasaur")
        #expect(details.height == 7)
        #expect(details.weight == 69)
        #expect(details.species.name == "bulbasaur")
        #expect(details.sprites.officialArtworkURL == URL(string: "https://example.com/artwork/1.png"))
        #expect(details.types.map(\.name) == ["grass", "poison"])
    }

    @Test func decodesNullArtworkAndArbitraryTypeNames() throws {
        let data = try TestJSONLoader.load(file: "charmander_details_unknown_type")
        let details = try JSONDecoder.default.decode(PokemonDetailsDTO.self, from: data)

        #expect(details.sprites.officialArtworkURL == nil)
        #expect(details.types.map(\.name) == ["fire", "mystery"])
    }
}
