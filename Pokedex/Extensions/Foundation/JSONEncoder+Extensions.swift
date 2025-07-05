// Created on 23/02/2023.

import Foundation

extension JSONEncoder {
    static var `default`: JSONEncoder {
        .default()
    }

    static func `default`(
        keyEncodingStrategy: KeyEncodingStrategy = .convertToSnakeCase,
        dateEncodingStrategy: DateEncodingStrategy = .iso8601
    ) -> JSONEncoder {
        let jsonEcoder = JSONEncoder()
        jsonEcoder.keyEncodingStrategy = keyEncodingStrategy
        jsonEcoder.dateEncodingStrategy = dateEncodingStrategy
        return jsonEcoder
    }
}
