//
//  ArrayExtensionsTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct ArrayExtensionsTests {

    @Test func resultBuilderInitCollectsElements() {
        let condition = true
        let array = Array<Int> {
            1
            2
            if condition {
                3
            } else {
                4
            }
        }
        #expect(array == [1, 2, 3])
    }
}
