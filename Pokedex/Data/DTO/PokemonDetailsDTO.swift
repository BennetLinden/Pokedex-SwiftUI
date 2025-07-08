//
//  PokemonDetailDTO.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct PokemonDetailsDTO: Decodable {
    let id: Int
    let name: String
    let height: Int // The height of this Pokémon in decimetres.
    let weight: Int // The weight of this Pokémon in hectograms.
    let species: NamedResourceDTO
    let sprites: PokemonSpritesDTO
}


