//
//  Rate.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

struct Rate: Codable {

    // Roadmap
    let id: String
    let version: String
    let skills: [Skill]

    enum CodingKeys: String, CodingKey {
        case id = "spec_id"
        case version
        case skills
    }
}
