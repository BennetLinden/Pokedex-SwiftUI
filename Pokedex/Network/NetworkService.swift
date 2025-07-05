//
//  NetworkService.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import Alamofire
import Foundation
import OSLog

final class NetworkService: Network {
    private let session: Session

    init(session: Session) {
        self.session = session
    }

    // MARK: Request

    func request<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        response: ResponseBody.Type,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        let response = await session
            .request(request, interceptor: interceptor)
            .validate()
            .serializingDecodable(
                ResponseBody.self,
                automaticallyCancelling: true,
                decoder: decoder
            )
            .response

        #if DEBUG
            log(response)
        #endif

        lazy var headers = response.response?.headers ?? HTTPHeaders()

        switch response.result {
        case .success(let body):
            return (headers, body)
        case .failure(let error):
            throw NetworkError(error, responseData: response.data)
        }
    }

    @discardableResult
    func request(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?
    ) async throws -> HTTPHeaders {
        let response = await session
            .request(request, interceptor: interceptor)
            .validate()
            .serializingData(
                automaticallyCancelling: true
            )
            .response

        #if DEBUG
            log(response)
        #endif

        lazy var headers = response.response?.headers ?? HTTPHeaders()

        switch response.result {
        case .success:
            return headers
        case .failure(let error):
            throw NetworkError(error, responseData: response.data)
        }
    }

    // MARK: - Download

    func download<ResponseBody: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, body: ResponseBody) {
        let response = await session
            .download(request, interceptor: interceptor, to: destination)
            .validate()
            .serializingDecodable(
                ResponseBody.self,
                automaticallyCancelling: true,
                decoder: decoder
            )
            .response

        lazy var headers = response.response?.headers ?? HTTPHeaders()

        switch response.result {
        case .success(let body):
            return (headers, body)
        case .failure(let error):
            throw NetworkError(error)
        }
    }

    func download(
        _ request: URLRequestConvertible,
        interceptor: RequestInterceptor?,
        destination: DownloadDestination?
    ) async throws -> (headers: HTTPHeaders, url: URL) {
        let response = await session
            .download(request, interceptor: interceptor, to: destination)
            .validate()
            .serializingDownloadedFileURL(automaticallyCancelling: true)
            .response

        lazy var headers = response.response?.headers ?? HTTPHeaders()

        switch response.result {
        case .success(let url):
            return (headers, url)
        case .failure(let error):
            throw NetworkError(error)
        }
    }

    private func log<T>(_ response: DataResponse<T, AFError>) {
        let method = "\(response.request?.urlRequest?.method?.rawValue)"
        let url = "\(response.request?.urlRequest?.url?.absoluteString.removingPercentEncoding)"
        let requestBody = "\(json: response.request?.httpBody)"
        let statusCode = "\(response.response?.statusCode)"
        let responseBody = "\(json: response.data)"

        let level = switch response.result {
        case .success:
            OSLogType.debug
        case .failure(.responseValidationFailed(.unacceptableStatusCode(let statusCode))) where statusCode >= 500:
            OSLogType.fault
        case .failure:
            OSLogType.error
        }

        let requestString = "REQUEST \(method) \(url) \(requestBody)"
        let responseString = "RESPONSE \(statusCode) \(responseBody)"

        Logger.network.log(level: level, "\(requestString)\n\(responseString)")
    }
}

