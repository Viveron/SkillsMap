//
//  Roadmap.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

struct Roadmap: Codable {

    let id: String
    let version: String
    let name: String
    let root: String
    let tree: [Leaf]
    let query: [Query]
}
