//
//  ContentView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import SwiftUI

struct HomeView: View {
    private let getPokemonReferences = GetPokemonReferencesUseCase()
    
    @State private var pokemon: [PokemonReference] = []
    
    var body: some View {
        NavigationStack {
            PokemonGridView(
                pokemon: pokemon
            )
            .padding(.bottom, 20)
            .ignoresSafeArea(edges: .bottom)
            .background(.gray06)
            .navigationDestination(for: PokemonReference.self) { pokemonReference in
                PokemonDetailsView(
                    pokemonReference: pokemonReference
                )
            }
        }
        .tint(.gray01)
        .task {
            do {
                pokemon = try await getPokemonReferences()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
