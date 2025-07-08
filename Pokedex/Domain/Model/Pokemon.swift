//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let height: Int // The height of this Pokémon in decimetres.
    let weight: Int // The weight of this Pokémon in hectograms.
}
    
extension Pokemon {
    init(details: PokemonDetailsDTO) {
        self.id = details.id
        self.name = details.name
        self.height = details.height
        self.weight = details.weight
    }
}
