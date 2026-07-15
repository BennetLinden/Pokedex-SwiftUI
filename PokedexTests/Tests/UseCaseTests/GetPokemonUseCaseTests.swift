//
//  GetPokemonUseCaseTests.swift
//  PokedexTests
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct GetPokemonUseCaseTests {

    @Test func getPokemonFromDetailsAndSpecies() async throws {
        let details = PokemonDetailsDTO.sample()
        let species = PokemonSpeciesDTO.sample()
        let pokemonService = PokemonServiceMock()
        pokemonService.getPokemonDetailsReturnValue = .success(details)
        pokemonService.getPokemonSpeciesReturnValue = .success(species)
        let sut = GetPokemonUseCase(
            pokemonService: pokemonService
        )

        let pokemon = try await sut(from: URL(string: "https://example.com")!)

        #expect(pokemon.id == details.id)
        #expect(pokemon.name == details.name)
        #expect(pokemon.isMythical == species.isMythical)
        #expect(pokemon.isLegendary == species.isLegendary)
    }

    @Test func throwsNetworkErrorWhenServiceFailsWithNetworkError() async {
        let pokemonService = PokemonServiceMock()
        pokemonService.getPokemonDetailsReturnValue = .failure(NetworkError.notConnectedToInternet)
        let sut = GetPokemonUseCase(
            pokemonService: pokemonService
        )

        await #expect {
            try await sut(from: URL(string: "https://example.com")!)
        } throws: { error in
            guard case GetPokemonError.network(let networkError) = error else { return false }
            return networkError == .notConnectedToInternet
        }
    }

    @Test func wrapsUnknownErrorAsGeneralError() async {
        let pokemonService = PokemonServiceMock()
        pokemonService.getPokemonDetailsReturnValue = .failure(TestError.generic)
        let sut = GetPokemonUseCase(
            pokemonService: pokemonService
        )

        await #expect {
            try await sut(from: URL(string: "https://example.com")!)
        } throws: { error in
            if case GetPokemonError.error = error { return true }
            return false
        }
    }
}
