//
//  GetPokemonDetailRequest.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Alamofire
import Foundation

struct GetPokemonDetailsRequest: NetworkRequest {
    var method: HTTPMethod {
        .get
    }
    
    let url: any URLConvertible
}


