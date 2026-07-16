//
//  TestRequest.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Alamofire
import Foundation

struct TestRequest: URLRequestConvertible {
    var url = URL(string: "https://example.com")!

    func asURLRequest() throws -> URLRequest {
        URLRequest(url: url)
    }
}
