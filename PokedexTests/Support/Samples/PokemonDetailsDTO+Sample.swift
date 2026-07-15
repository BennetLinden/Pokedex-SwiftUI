//
//  PokemonDetailsDTO+Sample.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 14/07/2026.
//

import Foundation
@testable import Pokedex

extension PokemonDetailsDTO {
    static func sample(
        id: Int = 1,
        name: String = "Name",
        height: Int = 10,
        weight: Int = 10,
        species: NamedResourceDTO = .sample(),
        sprites: PokemonSpritesDTO = .sample(),
        types: [NamedResourceDTO] = [.sample()]
    ) -> PokemonDetailsDTO {
        PokemonDetailsDTO(
            id: id,
            name: name,
            height: height,
            weight: weight,
            species: species,
            sprites: sprites,
            types: types
        )
    }
}
