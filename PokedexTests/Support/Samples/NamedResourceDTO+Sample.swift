//
//  NamedResourceDTO+Sample.swift
//  PokedexTests
//
//  Created by Bennet van der Linden on 14/07/2026.
//

import Foundation
@testable import Pokedex

extension NamedResourceDTO {
    static func sample(
        name: String = "Name",
        url: URL = URL(string: "https://example.com")!
    ) -> NamedResourceDTO {
        NamedResourceDTO(
            name: name,
            url: url
        )
    }
}
