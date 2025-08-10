//
//  EnvironmentValues+Extensions.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

extension EnvironmentValues {
    private struct IsLoadingKey: EnvironmentKey {
        static let defaultValue = false
    }
    
    var isLoading: Bool {
        get { self[IsLoadingKey.self] }
        set { self[IsLoadingKey.self] = newValue }
    }
}
