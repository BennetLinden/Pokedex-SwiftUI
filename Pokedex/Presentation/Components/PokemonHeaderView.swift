//
//  PokemonHeaderView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import SwiftUI

struct PokemonHeaderView: View {
    let name: String
    let id: Int
    let types: [PokemonType]
    let isLegendary: Bool
    let isMythical: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.gray01)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("#\(pokemonId: id)")
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                    .foregroundStyle(.gray03)
            }
            
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
    }
}

