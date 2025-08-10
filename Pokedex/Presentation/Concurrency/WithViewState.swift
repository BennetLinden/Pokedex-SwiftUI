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
    run: () async throws -> Content
) async -> Content? {
    do {
        let value = try await withThrowingViewState(state, run: run)
        return value
    } catch {
        return nil
    }
}

@MainActor
@discardableResult
func withThrowingViewState<Content>(
    _ state: Binding<ViewState<Content>>,
    run: () async throws -> Content
) async rethrows -> Content? {
    state.wrappedValue = .loading
    do {
        let value = try await run()
        state.wrappedValue = .content(value)
        return value
    } catch  {
        state.wrappedValue = .error(error)
        throw error
    }
}
