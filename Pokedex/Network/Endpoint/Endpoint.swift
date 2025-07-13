//
//  Endpoint.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import Alamofire
import Foundation

enum EndpointError: Error {
    case invalidURL
}

struct Endpoint: URLConvertible {
    let baseUrl: URL
    let path: String
    var queryItems: [URLQueryItem]?
}

extension Endpoint {
    func append(queryItems: [URLQueryItem]) -> Endpoint {
        var copy = self
        copy.queryItems = (copy.queryItems ?? []) + queryItems
        return copy
    }
}

extension Endpoint {
    func asURL() throws -> URL {
        guard
            var components = URLComponents(
                url: baseUrl,
                resolvingAgainstBaseURL: false
            )
        else {
            throw EndpointError.invalidURL
        }
        
        components.append(path: path)
        components.queryItems = queryItems

        guard let url = components.url else {
            throw EndpointError.invalidURL
        }
        
        return url
    }
}

