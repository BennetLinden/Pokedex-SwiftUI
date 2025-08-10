//
//  PokemonTypesView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

struct PokemonTypesRow: View {
    let types: [PokemonType]
    let isLegendary: Bool
    let isMythical: Bool
    
    var body: some View {
        HStack {
            if isLegendary {
                PokemonRarityView(rarity: .legendary)
            }
            
            if isMythical {
                PokemonRarityView(rarity: .mythical)
            }
            
            ForEach(types) { type in
                PokemonTypeView(pokemonType: type)
            }
        }
    }
    
    static var placeholder: some View {
        PokemonTypesRow(
            types: [.grass],
            isLegendary: false,
            isMythical: false
        )
        .redacted(reason: .placeholder)
    }
}
