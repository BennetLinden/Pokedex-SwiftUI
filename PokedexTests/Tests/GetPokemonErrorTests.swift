//
//  GetPokemonErrorTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct GetPokemonErrorTests {
    @Test func classifiesNetworkError() {
        let error = GetPokemonError(NetworkError.timedOut)

        guard case .network(let networkError) = error else {
            Issue.record("Expected .network, got \(error)")
            return
        }
        #expect(networkError == .timedOut)
    }

    @Test func classifiesGenericError() {
        let error = GetPokemonError(TestError.generic)

        if case .error = error {} else {
            Issue.record("Expected .error, got \(error)")
        }
    }

    @Test func networkErrorProducesRetryableAlert() {
        let error = GetPokemonError.network(.notConnectedToInternet)
        var didRetry = false

        let alert = error.asAlert(retryAction: { didRetry = true })

        #expect(alert.title == "No Internet")
        #expect(alert.buttons.count == 2) // retry + ok
        alert.buttons.first?.action()
        #expect(didRetry == true)
    }

    @Test func genericErrorProducesGeneralAlert() {
        let error = GetPokemonError.error(TestError.generic)

        let alert = error.asAlert(retryAction: nil)

        #expect(alert.title == "Something went wrong")
        #expect(alert.buttons.count == 1)
    }
}
