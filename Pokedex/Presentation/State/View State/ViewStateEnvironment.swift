//
//  ViewStateEnvironment.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 11/08/2025.
//

import Foundation

struct ViewStateEnvironment {
    var isRefreshing: Bool = false
    var error: Error? = nil
    var lastUpdatedAt: Date? = nil
}
