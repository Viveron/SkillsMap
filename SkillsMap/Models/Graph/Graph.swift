//
//  Graph.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

class Graph {

    let version: String
    let root: GraphElement

    init(version: String, root: GraphElement) {
        self.version = version
        self.root = root
    }

    // Обход элементов слева
    func skillsIdsPath(by element: GraphElement) -> [String] {
        var ids: [String] = []

        if element.isLeaf {
            ids = [element.leaf.id]
        } else {
            element.elements?.forEach {
                ids.append(contentsOf: skillsIdsPath(by: $0))
            }
        }

        return ids
    }
}
