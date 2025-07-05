//
//  Logger+Extensions.swift
//  Swift Tool Kit
//
//  Created by Bennet van der Linden on 26/08/2024.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!

    static let network = Logger(
        subsystem: subsystem,
        category: "Network"
    )

    static let general = Logger(
        subsystem: subsystem,
        category: "General"
    )
}
