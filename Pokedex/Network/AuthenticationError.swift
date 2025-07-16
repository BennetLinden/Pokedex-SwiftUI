//
//  AuthenticationError.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 16/07/2025.
//

import Foundation

enum AuthenticationError: Error, Equatable {
    case unauthorized
    case refreshTokenExpiredOrInvalid
    case missingCredential
    case excessiveRefresh
}
