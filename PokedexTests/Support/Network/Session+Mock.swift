//
//  Session+Mock.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Alamofire
import Foundation

extension Session {
    static func mock() -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return Session(configuration: configuration)
    }
}
