//
//  AlertViewModifier.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//


import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding var alert: Alert?
    
    private var isPresented: Binding<Bool> {
        Binding<Bool>(
            get: {
                alert != nil
            }, set: { newValue in
                guard !newValue else { return }
                alert = nil
            }
        )
    }
  
    func body(content: Content) -> some View {
        content
            .alert(
            alert?.title ?? "",
            isPresented: isPresented,
            presenting: alert
        ) { alert in
            ForEach(Array(alert.buttons.enumerated()), id: \.offset) { _, button in
                Button(
                    role: button.role,
                    action: button.action
                ) {
                    Text(button.title)
                }
            }
        } message: { alert in
            if let message = alert.message {
                Text(message)
            }
        }
    }
}

extension View {
    func alert(_ alert: Binding<Alert?>) -> some View {
        modifier(AlertViewModifier(alert: alert))
    }
}
