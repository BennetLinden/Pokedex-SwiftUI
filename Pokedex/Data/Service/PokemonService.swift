//
//  PokemonService.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

protocol PokemonService {
    func getAllPokemon() async throws -> ResultsDTO<[PokemonListItemDTO]>
}

actor DefaultPokemonService: PokemonService {
    private let network: Network

    init(
        network: Network,
    ) {
        self.network = network
    }

    init() {
        @Injected(\.network) var network
        self.init(
            network: network,
        )
    }
    
    func getAllPokemon() async throws -> ResultsDTO<[PokemonListItemDTO]> {
        try await network.request(
            GetAllPokemonRequest(
                limit: 151
            ),
        )
    }
}
