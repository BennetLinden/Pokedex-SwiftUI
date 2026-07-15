//
//  WithViewStateTests.swift
//  PokedexTests
//

import Testing
import SwiftUI
@testable import Pokedex

@MainActor
@Suite struct WithViewStateTests {
    /// Reference box backing a `Binding` so the state machine can be driven in a test.
    private final class Box<T> {
        var value: T
        init(_ value: T) { self.value = value }
    }

    private func makeBinding<T>(
        _ initial: ViewState<T>
    ) -> (box: Box<ViewState<T>>, binding: Binding<ViewState<T>>) {
        let box = Box(initial)
        let binding = Binding(get: { box.value }, set: { box.value = $0 })
        return (box, binding)
    }

    @Test func successSetsContent() async {
        let (box, binding) = makeBinding(ViewState<Int>.loading())

        let result = await withViewState(binding) { 42 }

        #expect(result == 42)
        if case .content(let value, _) = box.value {
            #expect(value == 42)
        } else {
            Issue.record("Expected .content, got \(box.value)")
        }
    }

    @Test func failureSetsErrorAndPreservesPreviousContent() async {
        let (box, binding) = makeBinding(ViewState.content(1, lastUpdatedAt: Date()))

        await #expect(throws: TestError.self) {
            try await withThrowingViewState(binding) { throw TestError.generic }
        }

        #expect(box.value.content == 1)
        #expect(box.value.errorWithPreviousContent != nil)
    }

    @Test func cancellationRestoresPreviousState() async {
        let (box, binding) = makeBinding(ViewState.content(5, lastUpdatedAt: Date()))

        await #expect(throws: CancellationError.self) {
            try await withThrowingViewState(binding) { throw CancellationError() }
        }

        #expect(box.value.content == 5)
        #expect(box.value.isRefreshing == false)
        if case .content = box.value {} else {
            Issue.record("Expected restored .content, got \(box.value)")
        }
    }

    @Test func nonThrowingVariantReturnsNilOnError() async {
        let (box, binding) = makeBinding(ViewState<Int>.loading())

        let result = await withViewState(binding) { throw TestError.generic }

        #expect(result == nil)
        #expect(box.value.errorWithPreviousContent == nil)
    }
}
