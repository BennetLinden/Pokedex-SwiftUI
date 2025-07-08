//
//  HectogramToKilogramStyle.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import SwiftUI

/// A FormatStyle that converts an Int (hectograms) into a String in kilograms.
struct HectogramToKilogramStyle: FormatStyle {

    /// How many fractional digits to show (e.g. "6.5 kg")
    var fractionDigits: Int = 1

    func format(_ value: Int) -> String {
        let kilograms = Double(value) / 10.0
        let format = "%.\(fractionDigits)f kg"
        return String(format: format, kilograms)
    }
}

extension FormatStyle where Self == HectogramToKilogramStyle {
    /// Handy shorthand for SwiftUI’s `format:` parameter
    static var hectogramsToKilograms: HectogramToKilogramStyle {
        HectogramToKilogramStyle()
    }
}
