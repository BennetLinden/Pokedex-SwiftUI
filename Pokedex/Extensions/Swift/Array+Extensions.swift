//
//  Array+Extensions.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//

import Foundation

extension Array {
    init(@ArrayBuilder<Element> builder: () -> [Element]) {
        self.init(builder())
    }
}
