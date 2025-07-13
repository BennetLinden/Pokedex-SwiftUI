## Pokedex

An iOS application built using SwiftUI and a lightweight architecture.

## Features

- Fetches a list of pokemon (first generation)
- Displays the pokemon in a grid
- Navigate to pokemon details
  - Show Pokemon Type
  - Show Pokemon About

## Highlights

- **Network layer** (`NetworkService.swift`, `NetworkRequest.swift`, etc.): A flexible, async/await-driven abstraction over Alamofire with strong typing, error handling, and clear extensibility.
- **Use Cases**: The domain logic lives in dedicated UseCases, which can easily be tested and shared between interactors.
- **Dependency injection**: A simple container and `@Injected` property wrappers with KeyPaths.
