//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import SwiftUI

struct PokemonDetailsView: View {
    let getPokemonDetails = GetPokemonUseCase()
    
    let pokemonReference: PokemonReference
    
    @State private var pokemon: Pokemon?
    
    var body: some View {
        ScrollView {
            VStack {
                PokemonHeaderView(
                    name: pokemonReference.name,
                    id: pokemonReference.id,
                    types: pokemon?.types.map(\.type) ?? []
                )
                
                AsyncImage(url: pokemon?.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .aspectRatio(1.0, contentMode: .fit)
                
                if let pokemon {
                    PokemonAboutView(pokemon: pokemon)
                        .padding(.bottom, 24)
                }
            }
            .padding()
        }
        .task {
            do {
                pokemon = try await getPokemonDetails(
                    from: pokemonReference.url
                )
                print(pokemon!)
            } catch {
                print(error)
            }
        }
    }
}
