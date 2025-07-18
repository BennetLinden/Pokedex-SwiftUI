//
//  GetPokemonReferencesUseCase.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

enum GetPokemonReferencesError: Error {
    case network(NetworkError)
    case error(Error)
    
    init(_ error: Error) {
        switch error {
        case let error as NetworkError:
            self = .network(error)
        default:
            self = .error(error)
        }
    }
}

extension GetPokemonReferencesError: AlertConvertible {
    func asAlert(retryAction: (() -> Void)?) -> Alert {
        Alert(
            title: "Error",
            message: "Try again!"
        )
    }
}

struct GetPokemonReferencesUseCase {
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    init() {
        @Injected(\.pokemonService) var pokemonService
        self.init(pokemonService: pokemonService)
    }
    
    func callAsFunction() async throws(GetPokemonReferencesError) -> [PokemonReference] {
        throw GetPokemonReferencesError.network(.cannotConnectToHost)
        do {
            return try await pokemonService.getPokemonReferences()
                .results
                .map(PokemonReference.init)
        } catch {
            throw GetPokemonReferencesError(error)
        }
    }
}
