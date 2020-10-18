//
//  PrepareTestViewController.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

class PrepareTestViewController: UIViewController {

    let titleLabel = UILabel()
    let textLabel = UILabel()

    let testView = TestView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#171717")

        titleLabel.textColor = UIColor("#DAD9D7")
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        view.addSubview(testView)
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        testView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        testView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    func configure(with element: GraphElement) {
        titleLabel.text = element.leaf.name
        testView.configure(with: element, index: 0)
    }
}
