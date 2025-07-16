//
//  NetworkError.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case authentication(AuthenticationError)
    case unacceptableStatusCode(Int, data: Data?)
    case responseDecodingFailed(DecodingError)
    case timedOut
    case notConnectedToInternet
    case cannotConnectToHost
    case networkConnectionLost
    case error(Error)
    case explicitlyCancelled

    var isConnectivityError: Bool {
        [
            NetworkError.timedOut,
            NetworkError.notConnectedToInternet,
            NetworkError.cannotConnectToHost,
            NetworkError.networkConnectionLost,
        ]
        .contains(self)
    }

    init(_ error: Error, responseData: Data? = nil) {
        switch error {
        case AFError.responseValidationFailed(reason: .customValidationFailed(let networkError as NetworkError)):
            self = networkError

        case AFError.responseValidationFailed(reason: .unacceptableStatusCode(401)):
            self = .authentication(.unauthorized)

        case AFError.responseValidationFailed(reason: .unacceptableStatusCode(let statusCode)):
            self = .unacceptableStatusCode(statusCode, data: responseData)

        case AFError.responseSerializationFailed(reason: .decodingFailed(let decodingError as DecodingError)):
            self = .responseDecodingFailed(decodingError)

        case AFError.requestAdaptationFailed(error: Alamofire.AuthenticationError.missingCredential):
            self = .authentication(.missingCredential)

        case AFError.requestAdaptationFailed(error: let error as NetworkError):
            self = error

        case AFError.requestAdaptationFailed(error: let error):
            self = NetworkError(error, responseData: responseData)

        case AFError.requestRetryFailed(retryError: Alamofire.AuthenticationError.missingCredential, _):
            self = .authentication(.missingCredential)

        case AFError.requestRetryFailed(retryError: Alamofire.AuthenticationError.excessiveRefresh, _):
            self = .authentication(.excessiveRefresh)

        case AFError.requestRetryFailed(retryError: NetworkError.authentication(.refreshTokenExpiredOrInvalid), _):
            self = .authentication(.refreshTokenExpiredOrInvalid)

        case AFError.requestRetryFailed(_, originalError: let error as NetworkError):
            self = error

        case AFError.requestRetryFailed(_, originalError: let error):
            self = NetworkError(error, responseData: responseData)

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorTimedOut:
            self = .timedOut

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorNotConnectedToInternet:
            self = .notConnectedToInternet

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorCannotConnectToHost:
            self = .cannotConnectToHost

        case AFError.sessionTaskFailed(let error as NSError) where error.code == NSURLErrorNetworkConnectionLost:
            self = .networkConnectionLost

        case AFError.explicitlyCancelled:
            self = .explicitlyCancelled

        default:
            self = .error(error)
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.authentication(let lhsAuthenticationError), .authentication(let rhsAuthenticationError)):
            return lhsAuthenticationError == rhsAuthenticationError

        case (.responseDecodingFailed, .responseDecodingFailed),
            (.timedOut, .timedOut),
            (.notConnectedToInternet, .notConnectedToInternet),
            (.cannotConnectToHost, .cannotConnectToHost),
            (.networkConnectionLost, .networkConnectionLost),
            (.explicitlyCancelled, .explicitlyCancelled):
            return true

        case (
            .unacceptableStatusCode(let lhsStatusCode, let lhsData),
            .unacceptableStatusCode(let rhsStatusCode, let rhsData)
        ):
            return lhsStatusCode == rhsStatusCode && lhsData == rhsData

        default:
            return false
        }
    }
}
