//
//  ResultDTO.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 06/07/2025.
//

import Foundation

struct ResultsDTO<Results: Decodable>: Decodable {
    let results: Results
}
