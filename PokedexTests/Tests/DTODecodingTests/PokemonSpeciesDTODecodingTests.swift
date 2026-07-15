//
//  PokemonSpeciesDTODecodingTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct PokemonSpeciesDTODecodingTests {

    @Test func decodesNonLegendarySpecies() throws {
        let data = try JSONData.load(file: "bulbasaur_species")
        let species = try JSONDecoder.default.decode(PokemonSpeciesDTO.self, from: data)

        #expect(species.id == 1)
        #expect(species.name == "bulbasaur")
        #expect(species.isLegendary == false)
        #expect(species.isMythical == false)
    }

    @Test func decodesLegendarySpecies() throws {
        let data = try JSONData.load(file: "mewtwo_species")
        let species = try JSONDecoder.default.decode(PokemonSpeciesDTO.self, from: data)

        #expect(species.isLegendary == true)
        #expect(species.isMythical == false)
    }
}
