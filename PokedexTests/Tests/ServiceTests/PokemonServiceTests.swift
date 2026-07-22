//
//  PokemonServiceTests.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 15/07/2026.
//

import Testing
import Foundation
@testable import Pokedex

@Suite struct PokemonServiceTests {

    // MARK: - References

    @Test func getPokemonReferencesRequestsFirst151Pokemon() async throws {
        let network = NetworkMock()
        let expected = ResultsDTO(results: [NamedResourceDTO.sample(name: "bulbasaur")])
        network.requestReturnValue = .success(expected)
        let sut = DefaultPokemonService(network: network)

        let result = try await sut.getPokemonReferences()

        #expect(result == expected)
        #expect(network.events == [.request(GetPokemonReferencesRequest(limit: 151))])
    }

    // MARK: - Details

    @Test func getPokemonDetailsRequestsGivenURL() async throws {
        let network = NetworkMock()
        let expected = PokemonDetailsDTO.sample(id: 1, name: "bulbasaur")
        network.requestReturnValue = .success(expected)
        let sut = DefaultPokemonService(network: network)
        let requestURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!

        let result = try await sut.getPokemonDetails(from: requestURL)

        #expect(result == expected)
        #expect(network.events == [.request(GetPokemonDetailsRequest(url: requestURL))])
    }

    // MARK: - Species

    @Test func getPokemonSpeciesRequestsGivenURL() async throws {
        let network = NetworkMock()
        let expected = PokemonSpeciesDTO.sample(id: 1, name: "bulbasaur")
        network.requestReturnValue = .success(expected)
        let sut = DefaultPokemonService(network: network)
        let requestURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/1/")!

        let result = try await sut.getPokemonSpecies(from: requestURL)

        #expect(result == expected)
        #expect(network.events == [.request(GetPokemonSpeciesRequest(url: requestURL))])
    }

    // MARK: - Error propagation

    @Test func propagatesErrorFromNetwork() async {
        let network = NetworkMock()
        network.requestReturnValue = .failure(NetworkError.timedOut)
        let sut = DefaultPokemonService(network: network)

        await #expect {
            try await sut.getPokemonReferences()
        } throws: { error in
            error as? NetworkError == .timedOut
        }
    }
}
