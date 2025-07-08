//
//  DecimeterToMeterFormatStyle.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/07/2025.
//

import SwiftUI

/// A FormatStyle that converts an Int (decimetres) into a String in meters.
struct DecimeterToMeterFormatStyle: FormatStyle {
    
    /// How many fractional digits to show (e.g. "1.7 m")
    var fractionDigits: Int = 1
    
    func format(_ value: Int) -> String {
        let meters = Double(value) / 10.0
        let format = "%.\(fractionDigits)f m"
        return String(format: format, meters)
    }
}

extension FormatStyle where Self == DecimeterToMeterFormatStyle {
    /// A handy shorthand
    static var decimetersToMeters: DecimeterToMeterFormatStyle {
        DecimeterToMeterFormatStyle()
    }
}
