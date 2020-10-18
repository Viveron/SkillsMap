//
//  Query.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

struct Query: Codable {

    let id: String
    let title: String
    let answers: [Answer]
    let correct: String
}
