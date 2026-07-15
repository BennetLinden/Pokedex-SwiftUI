//
//  ViewStateTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct ViewStateTests {
    private let date = Date(timeIntervalSince1970: 1_000)

    @Test func contentCaseExposesContentDateAndSnapshot() {
        let state = ViewState.content(42, lastUpdatedAt: date)

        #expect(state.content == 42)
        #expect(state.lastUpdatedAt == date)
        #expect(state.isRefreshing == false)
        #expect(state.errorWithPreviousContent == nil)

        let snapshot = state.contentSnapshot
        #expect(snapshot?.0 == 42)
        #expect(snapshot?.lastUpdatedAt == date)
    }

    @Test func loadingWithoutPreviousContentIsEmpty() {
        let state = ViewState<Int>.loading()

        #expect(state.content == nil)
        #expect(state.lastUpdatedAt == nil)
        #expect(state.isRefreshing == false)
        #expect(state.contentSnapshot == nil)
    }

    @Test func loadingWithPreviousContentIsRefreshing() {
        let state = ViewState.loading(previousContent: (content: 7, lastUpdatedAt: date))

        #expect(state.content == 7)
        #expect(state.lastUpdatedAt == date)
        #expect(state.isRefreshing == true)
    }

    @Test func errorWithoutPreviousContentExposesNothing() {
        let state = ViewState<Int>.error(TestError.generic)

        #expect(state.content == nil)
        #expect(state.lastUpdatedAt == nil)
        #expect(state.errorWithPreviousContent == nil)
        #expect(state.isRefreshing == false)
    }

    @Test func errorWithPreviousContentPreservesContent() {
        let state = ViewState.error(TestError.generic, previousContent: (content: 9, lastUpdatedAt: date))

        #expect(state.content == 9)
        #expect(state.lastUpdatedAt == date)
        #expect(state.errorWithPreviousContent != nil)
        #expect(state.isRefreshing == false)
    }
}
