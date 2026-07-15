//
//  PokemonServiceMock.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 14/07/2026.
//

import Foundation
@testable import Pokedex

class PokemonServiceMock: PokemonService {

    var getPokemonReferencesReturnValue: Result<ResultsDTO<[NamedResourceDTO]>, Error>!
    func getPokemonReferences() async throws -> ResultsDTO<[NamedResourceDTO]> {
        try getPokemonReferencesReturnValue.get()
    }

    var getPokemonDetailsReturnValue: Result<PokemonDetailsDTO, Error>!
    func getPokemonDetails(from url: URL) async throws -> PokemonDetailsDTO {
        try getPokemonDetailsReturnValue.get()
    }

    var getPokemonSpeciesReturnValue: Result<PokemonSpeciesDTO, Error>!
    func getPokemonSpecies(from url: URL) async throws -> PokemonSpeciesDTO {
        try getPokemonSpeciesReturnValue.get()
    }
}
