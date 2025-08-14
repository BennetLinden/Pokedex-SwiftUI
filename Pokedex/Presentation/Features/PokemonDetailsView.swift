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
    
    @State private var loadPokemonTask = TaskIdentifier()
    @State private var state: ViewState<Pokemon> = .loading()
    @State private var selectedTab: PokemonDetailsTab = .about
    @State private var alert: Alert?
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    PokemonHeaderView(
                        name: pokemonReference.name,
                        id: pokemonReference.id
                    )
                    
                    StateView(
                        state: state
                    ) { pokemon in
                        PokemonTypesRow(
                            types: pokemon.types.map(\.type),
                            isLegendary: pokemon.isLegendary,
                            isMythical: pokemon.isMythical
                        )
                    } loading: {
                        PokemonTypesRow.placeholder
                    }
                }
                
                AsyncImage(url: state.content?.imageURL) { phase in
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
                .frame(maxHeight: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.horizontal, 12)
                
                PokemonDetailsTabSwitcher(selectedTab: $selectedTab)
                
                StateView(
                    state: state
                ) { pokemon in
                    PokemonAboutView(pokemon: pokemon)
                        .padding(.bottom, 24)
                }
            }
            .padding()
        }
        .task(id: loadPokemonTask) {
            await loadPokemonDetails()
        }
        .alert($alert)
    }
    
    private func loadPokemonDetails() async {
        do {
            try await withThrowingViewState($state) {
                try await getPokemonDetails(
                    from: pokemonReference.url
                )
            }
        } catch let error as AlertConvertible {
            alert = error.asAlert(
                retryAction: {
                    loadPokemonTask.restart()
                }
            )
        } catch {
            alert = .Error.general
        }
    }
}

enum PokemonDetailsTab: String, CaseIterable {
    case about = "About"
    case stats = "Stats"
    case evolution = "Evolution"
}

struct PokemonDetailsTabSwitcher: View {
    @Binding var selectedTab: PokemonDetailsTab
    @Namespace private var underlineNamespace

    var body: some View {
        HStack(alignment: .top) {
            ForEach(PokemonDetailsTab.allCases, id: \.self) { tab in
                VStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.25)) {
                            selectedTab = tab
                        }
                    }) {
                        Text(tab.rawValue)
                            .font(.system(
                                size: 16,
                                weight: selectedTab == tab ? .semibold : .medium
                            ))
                            .foregroundStyle(selectedTab == tab ? .gray01 : .gray03)
                            .frame(maxWidth: .infinity)
                    }
                    
                    if selectedTab == tab {
                        Capsule()
                            .fill(Color.purple)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                    }
                }
            }
        }
        .background(alignment: .bottom) {
            Capsule()
                .fill(Color.gray06)
                .frame(height: 3)
        
        }
    }
}
