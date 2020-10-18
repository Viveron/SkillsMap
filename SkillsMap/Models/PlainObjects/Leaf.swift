//
//  Leaf.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

struct Leaf: Codable {

    let id: String
    let name: String
    let weight: Int
    let require: Int?
    let leafs: [String]?
    let queries: [String]?
}
