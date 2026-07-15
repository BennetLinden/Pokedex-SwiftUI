//
//  FormatStyleTests.swift
//  PokedexTests
//

import Testing
@testable import Pokedex

@Suite struct FormatStyleTests {
    @Test func decimeterToMeterFormatsWithOneFractionDigit() {
        #expect(DecimeterToMeterFormatStyle().format(7) == "0.7 m")
        #expect(DecimeterToMeterFormatStyle().format(17) == "1.7 m")
    }

    @Test func decimeterToMeterRespectsFractionDigits() {
        #expect(DecimeterToMeterFormatStyle(fractionDigits: 2).format(17) == "1.70 m")
        #expect(DecimeterToMeterFormatStyle(fractionDigits: 0).format(17) == "2 m")
    }

    @Test func hectogramToKilogramFormatsWithOneFractionDigit() {
        #expect(HectogramToKilogramStyle().format(69) == "6.9 kg")
        #expect(HectogramToKilogramStyle().format(5) == "0.5 kg")
    }

    @Test func hectogramToKilogramRespectsFractionDigits() {
        #expect(HectogramToKilogramStyle(fractionDigits: 0).format(69) == "7 kg")
    }
}
