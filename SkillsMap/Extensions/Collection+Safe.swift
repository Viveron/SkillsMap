//
//  Collection+Safe.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

extension Collection {

    subscript(safe index: Index) -> Iterator.Element? {
        get {
            if indices.contains(index) {
                return self[index]
            }
            return nil
        }
        set {
            if index < endIndex, let value = newValue {
                self[safe: index] = value
            }
        }
    }
}
