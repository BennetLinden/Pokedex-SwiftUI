//
//  ArrayBuilder.swift
//  Pokedex
//
//  Created by Bennet van der Linden on 18/07/2025.
//

import Foundation

@resultBuilder
enum ArrayBuilder<Element> {
    typealias Expression = Element
    typealias Component = [Element]

    static func buildBlock() -> Component { [] }

    static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    static func buildExpression(_ expression: [Expression]) -> Component {
        expression
    }
    
    static func buildExpression(_ expression: Expression?) -> Component {
        expression.map({ [$0] }) ?? []
    }

    static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    static func buildBlock(_ component: Component) -> Component {
        component
    }

    static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    static func buildEither(first component: Component) -> Component {
        component
    }

    static func buildEither(second component: Component) -> Component {
        component
    }

    static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }
}
