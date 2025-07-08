//
//  GetPokemonUseCase.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct GetPokemonUseCase {
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    init() {
        @Injected(\.pokemonService) var pokemonService
        self.init(pokemonService: pokemonService)
    }
    
    func callAsFunction(from url: URL) async throws -> Pokemon {
        let details = try await pokemonService.getPokemonDetails(
            from: url
        )
        let species = try await pokemonService.getPokemonSpecies(
            from: details.species.url
        )
        return Pokemon(
            details: details,
            species: species
        )
    }
}
