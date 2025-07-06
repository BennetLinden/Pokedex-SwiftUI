//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonListItem: PokemonListItem
    
    var body: some View {
        Text(pokemonListItem.name)
    }
}
