//
//  NetworkErrorTests.swift
//  PokedexTests
//
//  These tests intentionally import Alamofire to construct `AFError` values,
//  since `NetworkError`'s mapping is defined in terms of `AFError`.
//

import Testing
import Foundation
import Alamofire
@testable import Pokedex

@Suite struct NetworkErrorTests {
    @Test func mapsUnacceptableStatusCode() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        let error = NetworkError(afError)
        #expect(error == .unacceptableStatusCode(404, data: nil))
    }

    @Test func mapsUnauthorizedStatusToAuthentication() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
        let error = NetworkError(afError)
        #expect(error == .authentication(.unauthorized))
    }

    @Test func mapsExplicitlyCancelled() {
        let error = NetworkError(AFError.explicitlyCancelled)
        #expect(error == .explicitlyCancelled)
    }

    @Test func mapsTimedOutSessionTaskFailure() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        let error = NetworkError(AFError.sessionTaskFailed(error: underlying))
        #expect(error == .timedOut)
        #expect(error.isConnectivityError == true)
    }

    @Test func mapsUnknownErrorToErrorCase() {
        let error = NetworkError(TestError.generic)
        if case .error = error {} else {
            Issue.record("Expected .error, got \(error)")
        }
        #expect(error.isConnectivityError == false)
    }
}
