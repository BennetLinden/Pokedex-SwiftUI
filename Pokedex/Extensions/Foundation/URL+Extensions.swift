//
//  URL+Extensions.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Foundation

extension URL {
    static let pokemon: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api"
        return components.url!
    }()
}
