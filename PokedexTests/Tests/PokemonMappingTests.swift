//
//  PokemonMappingTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct PokemonMappingTests {

    @Test func mapsCoreFieldsFromDetailsAndSpecies() {
        let details = PokemonDetailsDTO.sample(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            sprites: .sample(officialArtworkURL: URL(string: "https://example.com/artwork/1.png")),
            types: [.sample(name: "grass"), .sample(name: "poison")]
        )
        let species = PokemonSpeciesDTO.sample(isLegendary: false, isMythical: false)

        let pokemon = Pokemon(details: details, species: species)

        #expect(pokemon.id == details.id)
        #expect(pokemon.name == details.name.capitalized)
        #expect(pokemon.height == details.height)
        #expect(pokemon.weight == details.weight)
        #expect(pokemon.imageURL == details.sprites.officialArtworkURL)
        #expect(pokemon.types.map(\.type) == [.grass, .poison])
        #expect(pokemon.isLegendary == species.isLegendary)
        #expect(pokemon.isMythical == species.isMythical)
    }

    @Test func filtersOutUnknownTypes() {
        let details = PokemonDetailsDTO.sample(
            types: [.sample(name: "fire"), .sample(name: "mystery")]
        )

        let pokemon = Pokemon(details: details, species: .sample())

        #expect(pokemon.types.map(\.type) == [.fire])
    }

    @Test func mapsMissingArtworkToNil() {
        let details = PokemonDetailsDTO.sample(
            sprites: .sample(officialArtworkURL: nil)
        )

        let pokemon = Pokemon(details: details, species: .sample())

        #expect(pokemon.imageURL == nil)
    }

    @Test func mapsLegendaryAndMythicalFlags() {
        let species = PokemonSpeciesDTO.sample(isLegendary: true, isMythical: true)

        let pokemon = Pokemon(details: .sample(), species: species)

        #expect(pokemon.isLegendary == species.isLegendary)
        #expect(pokemon.isMythical == species.isMythical)
    }
}
