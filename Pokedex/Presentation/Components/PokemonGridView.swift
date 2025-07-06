//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import SwiftUI

struct PokemonGridView: View {
    let pokemon: [PokemonListItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible())
                ],
                spacing: 20
            ) {
                ForEach(pokemon) { pokemon in
                    PokemonItemView(pokemon: pokemon)
                }
            }
            .padding()
        }
    }
}
