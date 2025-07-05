//
//  EncodableNetworkRequest.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//


import Alamofire
import Foundation

protocol EncodableNetworkRequest: NetworkRequest {
    associatedtype Body: Encodable & Sendable
    var body: Body { get }
    var encoder: JSONEncoder { get }
}

extension EncodableNetworkRequest {
    var encoder: JSONEncoder {
        .default
    }
}
