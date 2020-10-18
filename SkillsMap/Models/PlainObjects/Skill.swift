//
//  Skill.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

struct Skill: Codable {

    let id: String
    let total: Int
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id = "stat_id"
        case total
        case user
    }
}
