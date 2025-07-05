//
//  Injected.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

@propertyWrapper
struct Injected<Value> {
    private let keyPath: KeyPath<DependencyContainer, Value>

    init(_ keyPath: KeyPath<DependencyContainer, Value>) {
        self.keyPath = keyPath
    }

    var wrappedValue: Value {
        DependencyContainer[keyPath]
    }
}
