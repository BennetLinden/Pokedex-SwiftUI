//
//  GetAllPokemonUseCase.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

struct GetAllPokemonUseCase {
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    init() {
        @Injected(\.pokemonService) var pokemonService
        self.init(pokemonService: pokemonService)
    }
    
    func callAsFunction() async throws {
        try await pokemonService.getAllPokemon()
    }
}
