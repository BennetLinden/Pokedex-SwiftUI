//
//  GetPokemonReferencesUseCase.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

struct GetPokemonReferencesUseCase {
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    init() {
        @Injected(\.pokemonService) var pokemonService
        self.init(pokemonService: pokemonService)
    }
    
    func callAsFunction() async throws -> [PokemonReference] {
        try await pokemonService.getPokemonReferences()
            .results
            .map(PokemonReference.init)
    }
}
