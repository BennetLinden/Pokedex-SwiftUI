//
//  PokemonSpeciesDTO.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct PokemonSpeciesDTO: Decodable {
    let id: Int
    let name: String
//    let evolutionChain: EvolutionChainLink
//    let flavorTextEntries: [FlavorTextEntryDTO]
    let isLegendary: Bool
    let isMythical: Bool
}



