//
//  WithViewState.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

/// Runs `task` and drives `state` through its loading, content, and error
/// phases, swallowing any error the task throws.
///
/// Call this from a view's `.task` to load data into a ``ViewState``-backed
/// `@State` property.
/// Sets `state` to `.loading` immediately, then to `.content`
/// on success or `.error` on failure — except for `CancellationError`, where
/// `state` is left unchanged since the load was abandoned rather than failed.
///
/// Use this variant when the caller has no need to react to the failure beyond
/// what `state` already communicates (``ViewState/errorWithPreviousContent``
/// renders an error view). To also handle the error yourself — for example to
/// show an alert — use ``withThrowingViewState(_:preservePreviousContent:perform:)``
/// instead.
///
/// - Parameters:
///   - state: The binding to update as the task progresses.
///   - preservePreviousContent: Whether the current content, if any, should be
///     kept as `previousContent` in the `.loading` and `.error` states while
///     this task runs. Pass `false` to show a blank loading view instead, e.g.
///     when the load isn't a refresh of what's already on screen.
///   - task: The asynchronous work to perform. Its return value becomes the new content.
/// - Returns: The content on success, or `nil` if `task` threw.
@MainActor
@discardableResult
func withViewState<Content>(
    _ state: Binding<ViewState<Content>>,
    preservePreviousContent: Bool = true,
    perform task: () async throws -> Content
) async -> Content? {
    do {
        let value = try await withThrowingViewState(
            state,
            preservePreviousContent: preservePreviousContent,
            perform: task
        )
        return value
    } catch {
        return nil
    }
}

/// Runs `task` and drives `state` through its loading, content, and error
/// phases, rethrowing any error the task throws.
///
/// Behaves like ``withViewState(_:preservePreviousContent:perform:)``, except
/// the error is rethrown after `state` is updated to `.error`, so the caller
/// can react to it — for example to present an alert alongside the error
/// already reflected in `state`. `CancellationError` is rethrown without
/// touching `state`, leaving it as it was before this call.
///
/// - Parameters:
///   - state: The binding to update as the task progresses.
///   - preservePreviousContent: Whether the current content, if any, should be
///     kept as `previousContent` in the `.loading` and `.error` states while
///     this task runs. Pass `false` to show a blank loading view instead, e.g.
///     when the load isn't a refresh of what's already on screen.
///   - task: The asynchronous work to perform. Its return value becomes the new content.
/// - Returns: The content on success.
/// - Throws: Whatever error `task` throws, after `state` reflects it.
@MainActor
@discardableResult
func withThrowingViewState<Content>(
    _ state: Binding<ViewState<Content>>,
    preservePreviousContent: Bool = true,
    perform task: () async throws -> Content
) async rethrows -> Content {
    let currentState = state.wrappedValue
    
    let previousContent: (Content, Date)? = if preservePreviousContent {
        currentState.contentSnapshot
    } else {
        nil
    }
    
    state.wrappedValue = .loading(previousContent: previousContent)
    do {
        let value = try await task()
        state.wrappedValue = .content(value, lastUpdatedAt: Date())
        return value
    } catch let error as CancellationError {
        state.wrappedValue = currentState
        throw error
    } catch {
        state.wrappedValue = .error(error, previousContent: previousContent)
        throw error
    }
}
