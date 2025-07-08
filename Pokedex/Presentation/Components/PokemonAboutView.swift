//
//  PokemonAboutView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import SwiftUI

struct PokemonAboutView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.gray01)
            
            Grid(alignment: .leading, verticalSpacing: 10) {
                Row(
                    label: "Name",
                    value: pokemon.name
                )
                
                Row(
                    label: "ID",
                    value: "\(pokemonId: pokemon.id)"
                )
                
                Row(
                    label: "Height",
                    value: pokemon.height.formatted(.decimetersToMeters)
                )
                
                Row(
                    label: "Weight",
                    value: pokemon.weight.formatted(.hectogramsToKilograms)
                )
                
                Row(
                    label: "Types",
                    value: pokemon.types.map(\.type.name).joined(separator: ", ")
                )
            }
        }
    }
    
    struct Row: View {
        let label: String
        let value: String
        
        var body: some View {
            GridRow {
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray01)
                    .gridCellColumns(1)
                
                Text(value)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.gray02)
                    .gridCellColumns(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}




