//
//  AlertConvertible.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//


import SwiftUI

protocol AlertConvertible {
    func asAlert(retryAction: (() -> Void)?) -> Alert
}

extension AlertConvertible {
    func asAlert() -> Alert {
        asAlert(retryAction: nil)
    }
}
