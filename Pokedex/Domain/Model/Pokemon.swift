//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let imageURL: URL?
    let height: Int // The height of this Pokémon in decimetres.
    let weight: Int // The weight of this Pokémon in hectograms.
    let types: [PokemonTypeReference]

    let isLegendary: Bool
    let isMythical: Bool
    
}
    
extension Pokemon {
    init(
        details: PokemonDetailsDTO,
        species: PokemonSpeciesDTO
    ) {
        id = details.id
        name = details.name
        imageURL = details.sprites.officialArtworkURL
        height = details.height
        weight = details.weight
        
        types = details.types.compactMap {
            guard
                let type = PokemonType(rawValue: $0.name)
            else {
                return nil
            }
            return PokemonTypeReference(
                type: type,
                url: $0.url
            )
        }
        
        isLegendary = species.isLegendary
        isMythical = species.isMythical
    }
}
