//
//  DependencyContainer.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

struct DependencyContainer {
    private static var shared = DependencyContainer()
    
    /// A static subscript for accessing the `value` of `InjectionKey` instances.
    static subscript<Key: InjectionKey>(key: Key.Type) -> Key.Value {
        key.value
    }
    
    /// A static subscript accessor for reading dependencies in the shared container.
    static subscript<Value>(
        _ keyPath: KeyPath<DependencyContainer, Value>
    ) -> Value {
        shared[keyPath: keyPath]
    }
}

// MARK: - Network

extension DependencyContainer {
    private struct NetworkKey: InjectionKey {
        static let value: Network = NetworkService(session: .default)
    }

    var network: Network {
        DependencyContainer[NetworkKey.self]
    }
}

// MARK: - PokemonService

extension DependencyContainer {
    private struct PokemonServiceKey: InjectionKey {
        static let value: PokemonService = DefaultPokemonService()
    }

    var pokemonService: PokemonService {
        DependencyContainer[PokemonServiceKey.self]
    }
}
