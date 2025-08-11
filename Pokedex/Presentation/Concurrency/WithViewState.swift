//
//  WithViewState.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 10/08/2025.
//

import SwiftUI

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
