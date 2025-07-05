//
//  HTTPRequest.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 05/07/2025.
//

import Alamofire
import Foundation

protocol NetworkRequest: URLRequestConvertible {
    var method: HTTPMethod { get }
    var url: any URLConvertible { get }
    var headers: HTTPHeaders? { get }
    
    typealias RequestModifier = (inout URLRequest) throws -> Void
    var requestModifier: RequestModifier? { get }
}

extension NetworkRequest {
    var headers: HTTPHeaders? {
        nil
    }
    
    var requestModifier: RequestModifier? {
        nil
    }
}

extension NetworkRequest {

    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(
            url: url,
            method: method,
            headers: headers
        )
        
        try requestModifier?(&request)
        
        switch self {
        case let encodableRequest as any EncodableNetworkRequest:
            let encoder = JSONParameterEncoder(
                encoder: encodableRequest.encoder
            )
            return try encoder
                .encode(encodableRequest.body, into: request)
            
        case let dictionaryRequest as any DictionaryNetworkRequest:
            return try dictionaryRequest.encoding
                .encode(request, with: dictionaryRequest.parameters)
            
        default:
            return request
        }
    }
}
