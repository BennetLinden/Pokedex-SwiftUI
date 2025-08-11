//
//  StateView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/08/2025.
//

import SwiftUI

struct StateView<
    Content,
    ContentView: View,
    LoadingView: View,
    ErrorView: View
>: View {
    private let state: ViewState<Content>
    private let contentView: (Content) -> ContentView
    private let loadingView: () -> LoadingView
    private let errorView: (Error) -> ErrorView

    init(
        state: ViewState<Content>,
        @ViewBuilder content contentView: @escaping (Content) -> ContentView,
        @ViewBuilder loading loadingView: @escaping () -> LoadingView = { EmptyView() },
        @ViewBuilder error errorView: @escaping (Error) -> ErrorView = { _ in EmptyView() }
    ) {
        self.state = state
        self.contentView = contentView
        self.loadingView = loadingView
        self.errorView = errorView
    }

    var body: some View {
        switch state {
        case .content(let content):
            contentView(content)
        case .loading:
            loadingView()
        case .error(let error):
            errorView(error)
        }
    }
}
