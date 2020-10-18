//
//  GraphElement.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

extension GraphElement {

    enum State {

        case `default`
        case selected
        case hidden
    }
}

class GraphElement {

    let leaf: Leaf
    let queries: [Query]?
    let elements: [GraphElement]?

    var isRoot: Bool = false

    var isLeaf: Bool {
        return !(queries?.isEmpty ?? true)
    }

    var state: State = .default {
        didSet {
            elements?.forEach {
                $0.state = state
            }
        }
    }

    init(leaf: Leaf, queries: [Query]) {
        self.leaf = leaf
        self.queries = queries
        self.elements = nil
    }

    init(leaf: Leaf, elements: [GraphElement]) {
        self.leaf = leaf
        self.queries = nil
        self.elements = elements
    }
}
