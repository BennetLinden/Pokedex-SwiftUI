//
//  Alert.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//


import SwiftUI

struct Alert {
    let title: String
    var message: String? = nil
    var buttons: [Button] = [.ok]

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
    }
}
