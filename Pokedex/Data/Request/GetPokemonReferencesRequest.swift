//
//  GetPokemonReferencesRequest.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Alamofire
import Foundation

struct GetPokemonReferencesRequest: DictionaryNetworkRequest {
    let limit: Int
    
    var method: HTTPMethod {
        .get
    }
    
    var url: any URLConvertible {
        Endpoint.pokemon(.all)
    }
    
    var parameters: Parameters {
        ["limit": limit]
    }
}
