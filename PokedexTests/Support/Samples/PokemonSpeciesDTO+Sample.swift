//
//  PokemonSpeciesDTO+Sample.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 14/07/2026.
//

import Foundation
@testable import Pokedex

extension PokemonSpeciesDTO {
    static func sample(
        id: Int = 1,
        name: String = "Name",
        isLegendary: Bool = false,
        isMythical: Bool = false
    ) -> PokemonSpeciesDTO {
        PokemonSpeciesDTO(
            id: id,
            name: name,
            isLegendary: isLegendary,
            isMythical: isMythical
        )
    }
}
