//
//  PokemonGridItemView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import SwiftUI

struct PokemonGridItemView: View {
    let pokemon: PokemonReference
    
    var body: some View {
        VStack {
            AsyncImage(url: pokemon.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.black)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            
            Text(pokemon.name)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding([.horizontal, .top], 4)
        .padding(.bottom, 8)
        .background {
            Color.white
                .cornerRadius(8)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 5,
                    y: 2
                )
        }
    }
}
