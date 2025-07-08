//
//  PokemonTypeView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import SwiftUI

struct PokemonTypeView: View {
    let pokemonType: PokemonType
    
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(Color("Types/\(pokemonType.name)"))
                .frame(width: 12)
                .aspectRatio(1, contentMode: .fit)
            
            Text(pokemonType.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.gray01)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            Capsule(style: .circular)
                .fill(.gray06)
        )
    }
}
