//
//  Mock.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

class Mock {

    static func testGraph() -> Graph? {
        if let path = Bundle.main.path(forResource: "Test", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    let roadmap = try JSONDecoder().decode(Roadmap.self, from: data)
                    return GraphBuilder().buildGraph(from: roadmap)
                } catch {
                    //
                }
            }
        }
        return nil
    }

    static func testRate() -> Rate? {
        if let path = Bundle.main.path(forResource: "Test_rate", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    let rate = try JSONDecoder().decode(Rate.self, from: data)
                    return rate
                } catch {
                    // 
                }
            }
        }
        return nil
    }
}
