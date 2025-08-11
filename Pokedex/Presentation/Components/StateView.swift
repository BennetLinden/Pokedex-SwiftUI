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
    
    private var viewStateEnvironment: ViewStateEnvironment {
        ViewStateEnvironment(
            isRefreshing: state.isRefreshing,
            error: state.errorWithPreviousContent,
            lastUpdatedAt: state.lastUpdatedAt
        )
    }

    var body: some View {
        Group {
            switch state {
            case .content(let content, _):
                contentView(content)
            case .loading(let previousContent?):
                contentView(previousContent.content)
            case .loading:
                loadingView()
            case .error(_ , let previousContent?):
                contentView(previousContent.content)
            case .error(let error, _):
                errorView(error)
            }
        }
        .environment(\.viewState, viewStateEnvironment)
    }
}
