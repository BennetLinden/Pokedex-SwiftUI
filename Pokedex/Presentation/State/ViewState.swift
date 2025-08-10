//
//  ViewState.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//


import SwiftUI

enum ViewState<Content> {
    case content(Content)
    case loading
    case empty
    case error(Error)
    
    var content: Content? {
        switch self {
        case .content(let content):
            content
        default:
            nil
        }
    }
}