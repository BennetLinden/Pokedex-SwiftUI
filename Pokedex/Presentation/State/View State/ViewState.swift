//
//  ViewState.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

enum ViewState<Content> {
    case content(Content, lastUpdatedAt: Date)
    case loading(previousContent: (content: Content, lastUpdatedAt: Date)? = nil)
    case error(Error, previousContent: (content: Content, lastUpdatedAt: Date)? = nil)
    
    var content: Content? {
        switch self {
        case .content(let content, _):
            content
        case .error(_ ,let previousContent):
            previousContent?.content
        case .loading(let previousContent):
            previousContent?.content
        }
    }
    
    var lastUpdatedAt: Date? {
        switch self {
        case .content(_, let lastUpdatedAt):
            lastUpdatedAt
        case .loading(let previousContent):
            previousContent?.lastUpdatedAt
        case .error(_, let previousContent):
            previousContent?.lastUpdatedAt
        }
    }
    
    var isRefreshing: Bool {
        switch self {
        case .loading(.some):
            true
        default:
            false
        }
    }
    
    var errorWithPreviousContent: Error? {
        switch self {
        case .error(let error, .some):
            error
        default:
            nil
        }
    }
    
    var contentSnapshot: (Content, lastUpdatedAt: Date)? {
        guard let content, let lastUpdatedAt else { return nil }
        return (content, lastUpdatedAt)
    }
}
