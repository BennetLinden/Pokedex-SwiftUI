//
//  StringInterpolation+Extensions.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import Foundation

extension String.StringInterpolation {
    /// Interpolates an unwrapped optional value or `nil`.
    ///
    /// - Parameter value: Optional value to be interpolated
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
        appendInterpolation(value ?? "nil" as CustomStringConvertible)
    }

    /// Interpolates pretty printed JSON Data.
    ///
    /// - Parameter json: JSON data to be interpolated
    mutating func appendInterpolation(json data: Data?) {
        guard let jsonString = data
            .flatMap({ try? JSONSerialization.jsonObject(with: $0) })
            .flatMap({ try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) })
            .map({ String(decoding: $0, as: UTF8.self) })
        else {
            return
        }
        appendInterpolation(jsonString)
    }
    
    mutating func appendInterpolation(pokemonId id: Int) {
        appendInterpolation(String(format: "%03d", id))
    }
}
