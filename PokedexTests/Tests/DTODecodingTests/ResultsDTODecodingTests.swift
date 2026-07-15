//
//  ResultsDTODecodingTests.swift
//  PokedexTests
//
//  Covers the paginated results envelope and its NamedResourceDTO elements.
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct ResultsDTODecodingTests {

    @Test func decodesNamedResourceResults() throws {
        let data = try JSONData.load(file: "pokemon_references")
        let results = try JSONDecoder.default.decode(ResultsDTO<[NamedResourceDTO]>.self, from: data)

        #expect(results.results.map(\.name) == ["bulbasaur", "ivysaur"])
        #expect(results.results.first?.url == URL(string: "https://pokeapi.co/api/v2/pokemon/1/"))
    }
}
