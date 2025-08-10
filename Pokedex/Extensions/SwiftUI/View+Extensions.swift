//
//  View+Extensions.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

extension View {
    func isLoading(_ isLoading: Bool = true) -> some View {
        environment(\.isLoading, isLoading)
    }
}
