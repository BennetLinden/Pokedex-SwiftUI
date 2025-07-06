//
//  ContentView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import SwiftUI

struct HomeView: View {
    private let getAllPokemon = GetAllPokemonUseCase()
    
    @State private var pokemon: [PokemonListItem] = []
    
    var body: some View {
        NavigationStack {
            PokemonGridView(
                pokemon: pokemon
            )
            .padding()
            .background(Color.gray.opacity(0.1))
            .ignoresSafeArea(edges: .bottom)
        }
        .task {
            do {
                pokemon = try await getAllPokemon()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
