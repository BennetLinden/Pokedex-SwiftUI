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

    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody)

    @discardableResult
    func request(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?
    ) async throws -> HTTPHeaders

    // MARK: - Download

    typealias DownloadDestination = DownloadRequest.Destination

    func download<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody)

    func download(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, url: URL)
}

extension Network {
    // MARK: - Request

    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type = ResponseBody.self,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor? = nil
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        try await self.request(
            request,
            response: response,
            decoder: decoder,
            interceptor: interceptor
        )
    }
    
    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?
    ) async throws -> ResponseBody {
        try await self.request(
            request,
            response: response,
            decoder: decoder,
            interceptor: interceptor
        )
        .body
    }
    

    @discardableResult
    func request(_ request: URLRequestConvertible) async throws -> HTTPHeaders {
        try await self.request(request, interceptor: nil)
    }

    // MARK: - Download

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
