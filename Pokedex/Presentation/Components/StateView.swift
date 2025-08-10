//
//  StateView.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 08/08/2025.
//

import SwiftUI

enum ViewState<Content> {
    case content(Content)
    case loading
    case empty
    case error(Error)
}

struct StateView<
    Content,
    ContentStateView: View,
    LoadingStateView: View,
    EmptyStateView: View,
    ErrorStateView: View
>: View {
    private let state: ViewState<Content>
    private let contentView: (Content) -> ContentStateView
    private let loadingView: () -> LoadingStateView
    private let emptyView: () -> EmptyStateView
    private let errorView: (Error) -> ErrorStateView

    init(
        state: ViewState<Content>,
        @ViewBuilder content: @escaping (Content) -> ContentStateView,
        @ViewBuilder loading: @escaping () -> LoadingStateView = { EmptyView() },
        @ViewBuilder empty: @escaping () -> EmptyStateView = { EmptyView() },
        @ViewBuilder error: @escaping (Error) -> ErrorStateView = { _ in EmptyView() }
    ) {
        self.state = state
        contentView = content
        loadingView = loading
        emptyView = empty
        errorView = error
    }

    var body: some View {
        switch state {
        case .content(let content):
            contentView(content)
        case .loading:
            loadingView()
        case .empty:
            emptyView()
        case .error(let error):
            errorView(error)
        }
    }
}
