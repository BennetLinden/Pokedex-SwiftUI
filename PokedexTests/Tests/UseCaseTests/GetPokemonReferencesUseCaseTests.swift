//
//  GetPokemonReferencesUseCaseTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct GetPokemonReferencesUseCaseTests {

    @Test func getPokemonReferencesMapsResultsToReferences() async throws {
        let resources = [
            NamedResourceDTO.sample(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!),
            NamedResourceDTO.sample(name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!),
        ]
        let pokemonService = PokemonServiceMock()
        pokemonService.getPokemonReferencesReturnValue = .success(ResultsDTO(results: resources))
        let sut = GetPokemonReferencesUseCase(
            pokemonService: pokemonService
        )

        let references = try await sut()

        #expect(references.count == resources.count)
        #expect(references.map(\.name) == resources.map(\.name.capitalized))
        #expect(references.first?.id == 1)
    }

    @Test func throwsNetworkErrorWhenServiceFailsWithNetworkError() async {
        let pokemonService = PokemonServiceMock()
        pokemonService.getPokemonReferencesReturnValue = .failure(NetworkError.timedOut)
        let sut = GetPokemonReferencesUseCase(
            pokemonService: pokemonService
        )

        await #expect {
            try await sut()
        } throws: { error in
            guard case GetPokemonReferencesError.network(let networkError) = error else { return false }
            return networkError == .timedOut
        }
    }
}
