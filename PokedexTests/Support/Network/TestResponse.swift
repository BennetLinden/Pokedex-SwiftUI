//
//  TestResponse.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 16/07/2026.
//

import Foundation

struct TestResponse {
    var statusCode: Int = 200
    var data: Data?
    var headers: [String: String] = [:]
}
