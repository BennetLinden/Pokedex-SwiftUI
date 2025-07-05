//
//  DictionaryNetworkRequest.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//


import Alamofire
import Foundation

protocol DictionaryNetworkRequest: NetworkRequest {
    var parameters: Parameters { get }
}

extension DictionaryNetworkRequest {
    var encoding: ParameterEncoding {
        switch method {
        case .get, .delete, .head:
            URLEncoding(
                destination: .methodDependent,
                arrayEncoding: .noBrackets,
                boolEncoding: .literal
            )
        default:
            JSONEncoding.default
        }
    }
}
