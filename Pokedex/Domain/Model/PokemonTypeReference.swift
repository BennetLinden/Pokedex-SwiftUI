//
//  PokemonTypeReference.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import Foundation

struct PokemonTypeReference: Identifiable {
    let type: PokemonType
    let url: URL
    
    var id: String {
        type.rawValue
    }
}
