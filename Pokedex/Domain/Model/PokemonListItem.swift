//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct PokemonListItem: Identifiable {
    let name: String
    let url: URL
    
    var id: Int {
        url.pathComponents.last.flatMap(Int.init) ?? .zero
    }
        
    var imageURL: URL {
        URL.pokemonImages.appending(path: "pokemon/\(id).png")
    }
}
