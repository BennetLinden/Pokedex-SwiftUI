//
//  TaskIdentifier.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//

import SwiftUI

struct TaskIdentifier: Hashable {
    private var id = UUID()

    mutating func restart() {
        id = UUID()
    }
}
