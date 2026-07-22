//
//  ViewState.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

/// The load state of asynchronously fetched content, for driving a view through
/// loading, content, and error phases without losing what was last shown.
///
/// Use ``ViewState`` as the `@State` backing a view that loads data, and drive its
/// transitions with ``withViewState(_:preservePreviousContent:perform:)`` or
/// ``withThrowingViewState(_:preservePreviousContent:perform:)``. Feed the resulting
/// binding to ``StateView`` to render the right view for each case, or read
/// ``content``, ``isRefreshing``, and ``errorWithPreviousContent`` directly to build
/// a custom layout.
///
/// A refresh or retry keeps the previous content visible in the `.loading` and
/// `.error` cases via `previousContent`, so the UI can show a spinner or error
/// banner over stale content instead of blanking out.
enum ViewState<Content> {
    /// Content loaded successfully at `lastUpdatedAt`.
    case content(Content, lastUpdatedAt: Date)
    /// A load is in progress. `previousContent` carries the last successful
    /// content and its timestamp, if any, so it can stay on screen while loading.
    case loading(previousContent: (content: Content, lastUpdatedAt: Date)? = nil)
    /// The load failed with `Error`. `previousContent` carries the last successful
    /// content and its timestamp, if any, so it can stay on screen despite the failure.
    case error(Error, previousContent: (content: Content, lastUpdatedAt: Date)? = nil)

    /// The content to display: the current content, or the last successful
    /// content carried over from a `.loading` or `.error` state. `nil` only when
    /// no content has ever loaded.
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
    
    /// The timestamp of the most recent successful load, carried over from a
    /// `.loading` or `.error` state when no new content has loaded since.
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
    
    /// Whether a load is in progress while previous content is still available,
    /// i.e. a refresh rather than an initial load. Use this to show a spinner
    /// alongside existing content instead of replacing it with a loading view.
    var isRefreshing: Bool {
        switch self {
        case .loading(.some):
            true
        default:
            false
        }
    }
    
    /// The error, but only when previous content is still available to show
    /// alongside it. Use this to surface an error banner without losing the
    /// last successful content; `nil` when there's nothing to show behind the error.
    var errorWithPreviousContent: Error? {
        switch self {
        case .error(let error, .some):
            error
        default:
            nil
        }
    }
    
    /// The current content paired with its `lastUpdatedAt` timestamp, for
    /// passing as `previousContent` when starting a new load. `nil` unless both
    /// ``content`` and ``lastUpdatedAt`` are available.
    var contentSnapshot: (Content, lastUpdatedAt: Date)? {
        guard let content, let lastUpdatedAt else { return nil }
        return (content, lastUpdatedAt)
    }
}
