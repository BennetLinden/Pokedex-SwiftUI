//
//  URLComponents+Extions.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 13/07/2025.
//

import Foundation

extension URLComponents {
    /// Appends a single path component to the existing path, normalizing slashes.
    ///
    /// - Parameter pathComponent: A path component (e.g., "users/42") to append to the current path.
    mutating func append(path pathComponent: String) {
        guard pathComponent.isNotEmpty else { return }
        
        let existing = path.split(separator: "/").map(String.init)
        let new = pathComponent.split(separator: "/").map(String.init)
        
        path = "/" + (existing + new).joined(separator: "/")
    }
}
