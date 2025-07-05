//
//  DependencyContainer.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

struct DependencyContainer {
    private static var shared = DependencyContainer()

    /// A static subscript accessor for reading dependencies in the shared container.
    static subscript<Value>(_ keyPath: KeyPath<DependencyContainer, Value>) -> Value {
        shared[keyPath: keyPath]
    }
}

// MARK: - Network

extension DependencyContainer {
    var network: Network {
        NetworkService(session: .default)
    }
}
