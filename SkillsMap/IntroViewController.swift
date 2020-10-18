//
//  IntroViewController.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#171717")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let controller = UIAlertController(title: "Hi!", message: "Select you department", preferredStyle: .alert)
        controller.addAction(.init(title: "HR", style: .default, handler: { _ in
            UserService.roadmapId = "HR-0"
        }))
        controller.addAction(.init(title: "QA", style: .default, handler: { _ in
            UserService.roadmapId = "QA-0"
        }))

        present(controller, animated: true, completion: nil)
    }
}
