//
//  PokemonSpritesDTO+Sample.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 14/07/2026.
//

import Foundation
@testable import Pokedex

extension PokemonSpritesDTO {
    static func sample(
        officialArtworkURL: URL? = URL(string: "https://example.com/artwork.png")
    ) -> PokemonSpritesDTO {
        PokemonSpritesDTO(
            officialArtworkURL: officialArtworkURL
        )
    }
}
