//
//  GraphBuilder.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

class GraphBuilder {

    func buildGraph(from roadmap: Roadmap) -> Graph? {
        guard let leaf = roadmap.tree.first(where: { $0.id == roadmap.root }) else {
            return nil
        }

        let root = buildElement(from: leaf, in: roadmap)
        root.isRoot = true

        return Graph(version: roadmap.version, root: root)
    }

    // MARK: - Private methods

    private func buildElement(from leaf: Leaf, in roadmap: Roadmap) -> GraphElement {
        if  let ids = leaf.leafs {
            let leafs: [Leaf] = roadmap.tree.filter {
                ids.contains($0.id)
            }
            let elements: [GraphElement] = leafs.map {
                buildElement(from: $0, in: roadmap)
            }

            return GraphElement(leaf: leaf, elements: elements)
        } else {
            let ids: [String] = leaf.queries ?? []
            let queries: [Query] = roadmap.query.filter {
                ids.contains($0.id)
            }

            return GraphElement(leaf: leaf, queries: queries)
        }
    }
}
