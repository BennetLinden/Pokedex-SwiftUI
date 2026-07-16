//
//  URLProtocolMock.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Foundation

final class URLProtocolMock: URLProtocol {

    /// Produces the response for an intercepted request, or throws to simulate a
    /// transport-level failure (e.g. a `URLError`).
    /// Set this before each request.
    nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> TestResponse)?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            preconditionFailure("URLProtocolMock.requestHandler must be set before a request is made.")
        }

        do {
            let testResponse = try requestHandler(request)

            guard
                let url = request.url,
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: testResponse.statusCode,
                    httpVersion: "HTTP/1.1",
                    headerFields: testResponse.headers
                )
            else {
                client?.urlProtocol(self, didFailWithError: URLError(.badURL))
                return
            }

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = testResponse.data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
