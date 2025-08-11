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

extension EnvironmentValues {
    private struct ViewStateEnvironmentKey: EnvironmentKey {
        static let defaultValue = ViewStateEnvironment()
    }
    
    var viewState: ViewStateEnvironment {
        get { self[ViewStateEnvironmentKey.self] }
        set { self[ViewStateEnvironmentKey.self] = newValue }
    }
}
