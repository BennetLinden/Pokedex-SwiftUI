//
//  NetworkMock.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Alamofire
import Foundation
@testable import Pokedex

final class NetworkMock: Network, @unchecked Sendable {

    // MARK: - Events

    enum Event {
        case request(URLRequestConvertible)
        case requestWithoutBody(URLRequestConvertible)
        case download(URLRequestConvertible)
        case downloadFile(URLRequestConvertible)
    }

    private(set) var events: [Event] = []

    // MARK: - Request

    var requestReturnValue: Result<any Decodable, Error>!
    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        events.append(.request(request))
        return (HTTPHeaders(), try requestReturnValue.get() as! ResponseBody)
    }

    var requestWithoutBodyReturnValue: Result<HTTPHeaders, Error>!
    func request(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?
    ) async throws -> HTTPHeaders {
        events.append(.requestWithoutBody(request))
        return try requestWithoutBodyReturnValue.get()
    }

    // MARK: - Download

    var downloadReturnValue: Result<any Decodable, Error>!
    func download<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        events.append(.download(request))
        return (HTTPHeaders(), try downloadReturnValue.get() as! ResponseBody)
    }

    var downloadFileReturnValue: Result<URL, Error>!
    func download(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, url: URL) {
        events.append(.downloadFile(request))
        return (HTTPHeaders(), try downloadFileReturnValue.get())
    }
}

// Compares the *effective* request via the resolved URLRequest, since
// URLRequestConvertible isn't Equatable but URLRequest is.
extension NetworkMock.Event: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.request(lhsRequest), .request(rhsRequest)),
             let (.requestWithoutBody(lhsRequest), .requestWithoutBody(rhsRequest)),
             let (.download(lhsRequest), .download(rhsRequest)),
             let (.downloadFile(lhsRequest), .downloadFile(rhsRequest)):
            return (try? lhsRequest.asURLRequest()) == (try? rhsRequest.asURLRequest())
        default:
            return false
        }
    }
}
