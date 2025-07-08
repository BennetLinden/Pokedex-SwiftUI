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
    let types: [NamedResourceDTO]
    
    enum RootCodingKeys: String, CodingKey {
        case id, name, height, weight, species, sprites, types
    }

    enum TypeCodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        species = try container.decode(NamedResourceDTO.self, forKey: .species)
        sprites = try container.decode(PokemonSpritesDTO.self, forKey: .sprites)

        var unkeyedTypesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        var types: [NamedResourceDTO] = []

        while !unkeyedTypesContainer.isAtEnd {
            let typeContainer = try unkeyedTypesContainer.nestedContainer(keyedBy: TypeCodingKeys.self)
            let type = try typeContainer.decode(NamedResourceDTO.self, forKey: .type)
            types.append(type)
        }

        self.types = types
    }
}


