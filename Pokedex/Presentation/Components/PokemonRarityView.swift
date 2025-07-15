//
//  PokemonBadgeView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 15/07/2025.
//


import SwiftUI

struct PokemonRarityView: View {
    enum Rarity {
        case legendary
        case mythical

        var color: Color {
            switch self {
            case .legendary:
                .orange
            case .mythical:
                .purple
            }
        }

        var label: String {
            switch self {
            case .legendary: 
                "Legendary"
            case .mythical:
                "Mythical"
            }
        }
    }

    let rarity: Rarity

    @State private var rotation = Angle.degrees(0)
    
    var body: some View {
        Text(rarity.label)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Capsule()
                    .fill(rarity.color)
            )
            .overlay {
                Rectangle()
                    .foregroundStyle(
                        AngularGradient(
                            colors: [
                                .red, .orange, .yellow, .green,
                                .blue, .purple, .pink, .red
                            ],
                            center: .center,
                            angle: rotation
                        )
                    )
                    .blur(radius: 1.5)
                    .mask(
                        Capsule().stroke(lineWidth: 2)
                    )
                    .padding(1)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    rotation = .degrees(360)
                }
            }
    }
}
