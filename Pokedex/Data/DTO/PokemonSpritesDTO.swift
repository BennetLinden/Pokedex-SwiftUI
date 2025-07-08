//
//  PokemonSpritesDTO.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 07/07/2025.
//

import Foundation

struct PokemonSpritesDTO: Decodable {
    let officialArtworkURL: URL?

    private enum RootCodingKeys: String, CodingKey {
        case other
    }

    private enum OtherCodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }

    private enum OfficialArtworkCodingKeys: String, CodingKey {
        case frontDefault
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: RootCodingKeys.self
        )
        let otherContainer = try container.nestedContainer(
            keyedBy: OtherCodingKeys.self,
            forKey: .other
        )
        let officialArtworkContainer = try otherContainer.nestedContainer(
            keyedBy: OfficialArtworkCodingKeys.self,
            forKey: .officialArtwork
        )
        officialArtworkURL = try officialArtworkContainer
            .decodeIfPresent(URL.self, forKey: .frontDefault)
    }
}
