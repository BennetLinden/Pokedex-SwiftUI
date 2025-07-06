//
//  Network.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import Alamofire
import Foundation

protocol Network: AnyObject {
    // MARK: - Request
    
    /// Sends a network request and decodes the response body to the specified type.
    ///
    /// - Parameters:
    ///   - request: The request to send, conforming to `URLRequestConvertible`.
    ///   - response: The expected response body type, conforming to `Decodable`.
    ///   - decoder: The JSON decoder to use for decoding the response.
    ///   - interceptor: An optional `RequestInterceptor` for adapting or retrying the request.
    ///
    /// - Returns: A tuple containing the HTTP headers and the decoded response body.
    /// - Throws: An error if the request or decoding fails.
    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody)
    
    /// Sends a network request without expecting a response body.
    ///
    /// - Parameters:
    ///   - request: The request to send, conforming to `URLRequestConvertible`.
    ///   - interceptor: An optional `RequestInterceptor` for adapting or retrying the request.
    ///
    /// - Returns: The HTTP headers from the response.
    /// - Throws: An error if the request fails.
    @discardableResult
    func request(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?
    ) async throws -> HTTPHeaders

    // MARK: - Download

    /// A typealias for specifying a custom download destination.
    typealias DownloadDestination = DownloadRequest.Destination

    /// Downloads a file and decodes the downloaded data to the specified type.
    ///
    /// - Parameters:
    ///   - request: The request to send, conforming to `URLRequestConvertible`.
    ///   - decoder: The JSON decoder to use for decoding the downloaded data.
    ///   - interceptor: An optional `RequestInterceptor` for adapting or retrying the request.
    ///   - destination: An optional destination closure to control where the downloaded file is saved.
    ///
    /// - Returns: A tuple containing the HTTP headers and the decoded response body.
    /// - Throws: An error if the download or decoding fails.
    func download<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody)

    /// Downloads a file and provides the file's URL upon completion.
    ///
    /// - Parameters:
    ///   - request: The request to send, conforming to `URLRequestConvertible`.
    ///   - interceptor: An optional `RequestInterceptor` for adapting or retrying the request.
    ///   - destination: An optional destination closure to control where the downloaded file is saved.
    ///
    /// - Returns: A tuple containing the HTTP headers and the URL of the downloaded file.
    /// - Throws: An error if the download fails.
    func download(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, url: URL)
}

extension Network {
    // MARK: - Request

    /// Sends a network request and decodes the response body to the specified type, with default parameter values.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - response: The expected response body type (inferred by default).
    ///   - decoder: The JSON decoder to use (default is `JSONDecoder.default`).
    ///   - interceptor: An optional request interceptor (default is `nil`).
    ///
    /// - Returns: A tuple containing the HTTP headers and the decoded response body.
    /// - Throws: An error if the request or decoding fails.
    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type = ResponseBody.self,
        decoder: JSONDecoder = .default,
        interceptor: RequestInterceptor? = nil
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        try await self.request(
            request,
            response: response,
            decoder: decoder,
            interceptor: interceptor
        )
    }
    
    /// Sends a network request and returns only the decoded response body, discarding headers.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - response: The expected response body type (inferred by default).
    ///   - decoder: The JSON decoder to use (default is `JSONDecoder.default`).
    ///   - interceptor: An optional request interceptor (default is `nil`).
    ///
    /// - Returns: The decoded response body.
    /// - Throws: An error if the request or decoding fails.
    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type = ResponseBody.self,
        decoder: JSONDecoder = .default,
        interceptor: RequestInterceptor? = nil
    ) async throws -> ResponseBody {
        try await self.request(
            request,
            response: response,
            decoder: decoder,
            interceptor: interceptor
        )
        .body
    }

    /// Sends a network request without expecting a response body.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The HTTP headers from the response.
    /// - Throws: An error if the request fails.
    @discardableResult
    func request(_ request: URLRequestConvertible) async throws -> HTTPHeaders {
        try await self.request(request, interceptor: nil)
    }

    // MARK: - Download

    /// Downloads a file and decodes the downloaded data to the specified type, with optional parameters.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - decoder: The JSON decoder to use.
    ///   - interceptor: An optional request interceptor (default is `nil`).
    ///   - destination: An optional download destination (default is `nil`).
    ///
    /// - Returns: A tuple containing the HTTP headers and the decoded response body.
    /// - Throws: An error if the download or decoding fails.
    func download<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor? = nil,
        destination: DownloadDestination? = nil
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        try await download(
            request,
            decoder: decoder,
            interceptor: interceptor,
            destination: destination
        )
    }

    /// Downloads a file and provides the file's URL upon completion, with optional parameters.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - interceptor: An optional request interceptor (default is `nil`).
    ///   - destination: An optional download destination (default is `nil`).
    ///
    /// - Returns: A tuple containing the HTTP headers and the URL of the downloaded file.
    /// - Throws: An error if the download fails.
    func download(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor? = nil,
        destination: DownloadDestination? = nil
    ) async throws -> (headers: HTTPHeaders, url: URL) {
        try await download(
            request,
            interceptor: interceptor,
            destination: destination
        )
    }
}
