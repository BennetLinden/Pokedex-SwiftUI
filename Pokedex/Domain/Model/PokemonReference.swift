//
//  PokemonReference.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct PokemonReference: Identifiable, Hashable {
    let name: String
    let url: URL
    
    var id: Int {
        url.pathComponents.last.flatMap(Int.init) ?? .zero
    }
    
    var imageURL: URL {
        URL.pokemonImages.appending(path: "pokemon/\(id).png")
    }
}

extension PokemonReference {
    init(dto: NamedResourceDTO) {
        self.name = dto.name.capitalized
        self.url = dto.url
    }
}
