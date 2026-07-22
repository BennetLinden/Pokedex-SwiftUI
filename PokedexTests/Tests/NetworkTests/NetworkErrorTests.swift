//
//  NetworkErrorTests.swift
//  PokedexTests
//
//  These tests intentionally import Alamofire to construct `AFError` values,
//  since `NetworkError`'s mapping is defined in terms of `AFError`.
//

import Alamofire
import Foundation
import Testing
@testable import Pokedex

@Suite struct NetworkErrorTests {

    // MARK: - Status codes

    @Test func mapsUnacceptableStatusCode() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        let error = NetworkError(afError)
        #expect(error == .unacceptableStatusCode(404, data: nil))
    }

    @Test func unacceptableStatusCodeCarriesResponseData() {
        let responseData = Data("error body".utf8)
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        let error = NetworkError(afError, responseData: responseData)
        #expect(error == .unacceptableStatusCode(500, data: responseData))
    }

    // MARK: - Authentication

    @Test func mapsUnacceptableStatusCodeToUnauthorized() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
        let error = NetworkError(afError)
        #expect(error == .authentication(.unauthorized))
    }

    @Test func mapsAdaptationFailureToMissingCredential() {
        let afError = AFError.requestAdaptationFailed(error: Alamofire.AuthenticationError.missingCredential)
        let error = NetworkError(afError)
        #expect(error == .authentication(.missingCredential))
    }

    @Test func mapsRetryFailureToMissingCredential() {
        let afError = AFError.requestRetryFailed(
            retryError: Alamofire.AuthenticationError.missingCredential,
            originalError: TestError.generic
        )
        let error = NetworkError(afError)
        #expect(error == .authentication(.missingCredential))
    }

    @Test func mapsRetryFailureToExcessiveRefresh() {
        let afError = AFError.requestRetryFailed(
            retryError: Alamofire.AuthenticationError.excessiveRefresh,
            originalError: TestError.generic
        )
        let error = NetworkError(afError)
        #expect(error == .authentication(.excessiveRefresh))
    }

    @Test func mapsRetryFailureToRefreshTokenExpired() {
        let afError = AFError.requestRetryFailed(
            retryError: NetworkError.authentication(.refreshTokenExpiredOrInvalid),
            originalError: TestError.generic
        )
        let error = NetworkError(afError)
        #expect(error == .authentication(.refreshTokenExpiredOrInvalid))
    }

    // MARK: - Decoding

    @Test func mapsResponseDecodingFailure() {
        let decodingError = DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [], debugDescription: "corrupt")
        )
        let afError = AFError.responseSerializationFailed(reason: .decodingFailed(error: decodingError))
        let error = NetworkError(afError)

        // Equatable treats all `.responseDecodingFailed` as equal, so match the
        // wrapped error to prove the original DecodingError is carried through.
        guard case .responseDecodingFailed(.dataCorrupted(let context)) = error else {
            Issue.record("Expected .responseDecodingFailed(.dataCorrupted), got \(error)")
            return
        }
        #expect(context.debugDescription == "corrupt")
    }

    // MARK: - Connectivity

    @Test func mapsSessionFailureToTimedOut() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        let error = NetworkError(AFError.sessionTaskFailed(error: underlying))
        #expect(error == .timedOut)    }

    @Test func mapsSessionFailureToNotConnectedToInternet() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        let error = NetworkError(AFError.sessionTaskFailed(error: underlying))
        #expect(error == .notConnectedToInternet)    }

    @Test func mapsSessionFailureToCannotConnectToHost() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost)
        let error = NetworkError(AFError.sessionTaskFailed(error: underlying))
        #expect(error == .cannotConnectToHost)    }

    @Test func mapsSessionFailureToNetworkConnectionLost() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost)
        let error = NetworkError(AFError.sessionTaskFailed(error: underlying))
        #expect(error == .networkConnectionLost)    }

    // MARK: - Wrapped error passthrough & recursion

    @Test func passesThroughCustomResponseValidationError() {
        let customValidationError = NetworkError.unacceptableStatusCode(499, data: Data("passthrough".utf8))
        let afError = AFError.responseValidationFailed(
            reason: .customValidationFailed(error: customValidationError)
        )
        let error = NetworkError(afError)
        #expect(error == customValidationError)
    }

    @Test func passesThroughNetworkErrorFromAdaptation() {
        let requestAdaptationError = NetworkError.unacceptableStatusCode(499, data: Data("passthrough".utf8))
        let afError = AFError.requestAdaptationFailed(error: requestAdaptationError)
        let error = NetworkError(afError)
        #expect(error == requestAdaptationError)
    }

    @Test func remapsUnderlyingErrorFromAdaptation() {
        let requestAdaptationError = AFError.sessionTaskFailed(
            error: NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        )
        let afError = AFError.requestAdaptationFailed(error: requestAdaptationError)
        let error = NetworkError(afError)
        #expect(error == .timedOut)
    }

    @Test func passesThroughNetworkErrorFromRetryOriginal() {
        let original = NetworkError.unacceptableStatusCode(500, data: Data("passthrough".utf8))
        let afError = AFError.requestRetryFailed(
            retryError: TestError.generic,
            originalError: original
        )
        let error = NetworkError(afError)
        #expect(error == original)
    }

    @Test func remapsOriginalErrorFromRetry() {
        let original = AFError.sessionTaskFailed(
            error: NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost)
        )
        let afError = AFError.requestRetryFailed(
            retryError: TestError.generic,
            originalError: original
        )
        let error = NetworkError(afError)
        #expect(error == .cannotConnectToHost)
    }

    // MARK: - Passthrough / fallback

    @Test func mapsExplicitlyCancelled() {
        let error = NetworkError(AFError.explicitlyCancelled)
        #expect(error == .explicitlyCancelled)
    }

    @Test func mapsUnknownErrorToErrorCase() {
        let error = NetworkError(TestError.generic)

        guard case .error(TestError.generic) = error else {
            Issue.record("Expected .error(.generic), got \(error)")
            return
        }
    }

    // MARK: - isConnectivityError

    @Test func isConnectivityErrorIsTrueForConnectivityCases() {
        #expect(NetworkError.timedOut.isConnectivityError)
        #expect(NetworkError.notConnectedToInternet.isConnectivityError)
        #expect(NetworkError.cannotConnectToHost.isConnectivityError)
        #expect(NetworkError.networkConnectionLost.isConnectivityError)
    }

    @Test func isConnectivityErrorIsFalseForOtherCases() {
        let decodingError = DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [], debugDescription: "")
        )
        #expect(NetworkError.authentication(.unauthorized).isConnectivityError == false)
        #expect(NetworkError.unacceptableStatusCode(500, data: nil).isConnectivityError == false)
        #expect(NetworkError.responseDecodingFailed(decodingError).isConnectivityError == false)
        #expect(NetworkError.explicitlyCancelled.isConnectivityError == false)
        #expect(NetworkError.error(TestError.generic).isConnectivityError == false)
    }
}
