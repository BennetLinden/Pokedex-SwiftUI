//
//  InjectionKey.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

protocol InjectionKey {
    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The value for the dependency injection key.
    ///
    /// Just a `get` only as we don't plan to dynamically override depencies at runtime.
    static var value: Self.Value { get }
}
