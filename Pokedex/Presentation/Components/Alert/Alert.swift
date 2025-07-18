//
//  Alert.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//


import SwiftUI

struct Alert {
    let title: String
    let message: String?
    let buttons: [Button]
    
    init(
        title: String,
        message: String? = nil,
        buttons: [Button] = [.ok]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
    
    init(
        title: String,
        message: String? = nil,
        @ArrayBuilder<Button> buttons: () -> [Button]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons()
    }

    struct Button {
        let title: String
        let action: () -> Void
        let role: ButtonRole?

        init(
            title: String,
            role: ButtonRole? = nil,
            action: @escaping () -> Void = {}
        ) {
            self.title = title
            self.role = role
            self.action = action
        }

        static var ok: Button {
            Button(title: "OK")
        }
        
        static func retry(action: @escaping () -> Void) -> Button {
            return Button(
                title: "Retry",
                action: action
            )
        }
    }
}

extension Alert {
    enum Error {
        static var general: Alert {
            Alert(
                title: "Something went wrong",
                message: "Please try again later."
            )
        }
        
        static func network(
            error: NetworkError,
            retryAction: (() -> Void)?
        ) -> Alert {
            return switch error {
            case .notConnectedToInternet, .timedOut, .networkConnectionLost, .cannotConnectToHost:
                Alert(
                    title: "No Internet",
                    message: "Please check your internet connection and try again.",
                    buttons: {
                        if let retryAction {
                            .retry(action: retryAction)
                        }
                        .ok
                    }
                )
                
            case .responseDecodingFailed:
                Alert(
                    title: "Unexpected Error",
                    message: "The data could not be processed. Please try again later.",
                    buttons: [.ok]
                )
                
        case let .unacceptableStatusCode(code, _):
                Alert(
                    title: "Server Error",
                    message: "Server responded with status code \(code).",
                    buttons: {
                        if let retryAction {
                            .retry(action: retryAction)
                        }
                        .ok
                    }
                )
                
            case .authentication:
                Alert(
                    title: "Authentication Error",
                    message: "Your session has expired or you're not authorized. Please sign in again.",
                    buttons: [.ok]
                )
                
            case .explicitlyCancelled:
                Alert(
                    title: "Cancelled",
                    message: "The request was cancelled.",
                    buttons: [.ok]
                )
                
            case .error:
                Alert(
                    title: "Unexpected Error",
                    message: "Something went wrong. Please try again later.",
                    buttons: {
                        if let retryAction {
                            .retry(action: retryAction)
                        }
                        .ok
                    }
                )
            }
        }
    }
}

