//
//  NetworkServiceTests.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Alamofire
import Foundation
import Testing
@testable import Pokedex

@Suite(.serialized)
struct NetworkServiceTests {

    // MARK: - Validation

    @Test(arguments: [200, 201, 202])
    func succeedsForSuccessfulStatusCode(_ statusCode: Int) async throws {
        URLProtocolMock.requestHandler = { _ in
            TestResponse(
                statusCode: statusCode,
                data: Data("{}".utf8)
            )
        }
        let sut = NetworkService(session: .mock())

        try await sut.request(TestRequest())
    }

    @Test func succeedsForEmptyBody() async throws {
        // 204 No Content: a genuinely body-less response. (An empty 200 would be
        // rejected by Alamofire's data serializer as `inputDataNilOrZeroLength`.)
        URLProtocolMock.requestHandler = { _ in
            TestResponse(statusCode: 204)
        }
        let sut = NetworkService(session: .mock())

        try await sut.request(TestRequest())
    }

    @Test(arguments: [400, 401, 403, 404, 409, 500, 501, 502, 503])
    func throwsForUnsuccessfulStatusCode(_ statusCode: Int) async {
        URLProtocolMock.requestHandler = { _ in
            TestResponse(statusCode: statusCode, data: Data("{}".utf8))
        }
        let sut = NetworkService(session: .mock())

        await #expect(throws: NetworkError.self) {
            try await sut.request(TestRequest())
        }
    }

    // MARK: - Interceptor forwarding

    @Test func invokesProvidedInterceptor() async throws {
        URLProtocolMock.requestHandler = { _ in
            TestResponse(statusCode: 204)
        }
        let sut = NetworkService(session: .mock())

        try await confirmation("interceptor is invoked") { confirmation in
            let interceptor = Adapter { urlRequest, _, completion in
                confirmation.confirm()
                completion(.success(urlRequest))
            }

            try await sut.request(
                TestRequest(),
                interceptor: interceptor
            )
        }
    }

    // MARK: - Decoding

    @Test func decodesBodyOnSuccess() async throws {
        // Round-trip an arbitrary value through a test-owned type: the specific
        // value doesn't matter, only that the body decodes back into it.
        let expected = TestResponseBody(value: "decoded")
        let data = try JSONEncoder().encode(expected)
        URLProtocolMock.requestHandler = { _ in
            TestResponse(data: data)
        }
        let sut = NetworkService(session: .mock())

        let (_, body) = try await sut.request(
            TestRequest(),
            response: TestResponseBody.self
        )

        #expect(body == expected)
    }

    @Test func mapsDecodingFailure() async {
        URLProtocolMock.requestHandler = { _ in
            TestResponse(data: Data("{ not valid json".utf8))
        }
        let sut = NetworkService(session: .mock())

        await #expect {
            let _: TestResponseBody = try await sut.request(
                TestRequest(),
            )
        } throws: { error in
            guard case NetworkError.responseDecodingFailed = error else { return false }
            return true
        }
    }

    @Test func usesProvidedDecoder() async throws {
        // Confirm the given decoder is actually used, without depending on any
        // particular decoding configuration: a spy decoder reports when its
        // `decode(_:from:)` is called.
        URLProtocolMock.requestHandler = { _ in
            TestResponse(data: Data(#"{"value": "decoded"}"#.utf8))
        }
        let sut = NetworkService(session: .mock())

        try await confirmation("decoder is used") { confirmation in
            let decoder = JSONDecoderMock { confirmation.confirm() }

            let _: TestResponseBody = try await sut.request(
                TestRequest(),
                decoder: decoder
            )
        }
    }
}
