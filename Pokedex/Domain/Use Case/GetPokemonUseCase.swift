//
//  GetPokemonUseCase.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

enum GetPokemonError: Error {
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

extension GetPokemonError: AlertConvertible {
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

struct GetPokemonUseCase {
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    init() {
        @Injected(\.pokemonService) var pokemonService
        self.init(pokemonService: pokemonService)
    }
    
    func callAsFunction(
        from url: URL
    ) async throws(GetPokemonError) -> Pokemon {
        do {
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
        } catch {
            throw GetPokemonError(error)
        }
    }
}
