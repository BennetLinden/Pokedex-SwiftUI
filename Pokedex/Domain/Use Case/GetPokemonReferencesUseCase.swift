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
        switch self {
        case .network(let networkError):
            Alert.Error.network(
                error: networkError,
                retryAction: retryAction
            )
        case .error:
            Alert.Error.general
        }
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
        do {
            return try await pokemonService.getPokemonReferences()
                .results
                .map(PokemonReference.init)
        } catch {
            throw GetPokemonReferencesError(error)
        }
    }
}
