//
//  PokemonService.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

protocol PokemonService {
    func getPokemonReferences() async throws -> ResultsDTO<[NamedResourceDTO]>
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
    
    func getPokemonReferences() async throws -> ResultsDTO<[NamedResourceDTO]> {
        try await network.request(
            GetPokemonReferencesRequest(
                limit: 151
            ),
        )
    }
}
