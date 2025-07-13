//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//


import Alamofire
import Foundation

extension Endpoint {
    static func pokemon(_ pokemon: Pokemon) -> Endpoint {
        Endpoint(
            baseUrl: .pokemonAPI,
            path: pokemon.path
        )
    }
    
    enum Pokemon {
        case all
        
        var path: String {
            switch self {
            case .all: "v2/pokemon"
            }
        }
    }
}
