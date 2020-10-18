//
//  TestView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit
import RadioGroup

class TestView: UIView {

    let numberLabel = UILabel()
    let titleLabel = UILabel()
    let radioGroup = RadioGroup()

    var query: Query?
    var isPassed: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor("#171717")

        numberLabel.textColor = UIColor("#6C6874")
        numberLabel.font = .systemFont(ofSize: 12, weight: .regular)
        numberLabel.numberOfLines = 1

        titleLabel.textColor = UIColor("#DAD9D7")
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 0

        radioGroup.tintColor = UIColor("#6C6874")
        radioGroup.selectedColor = UIColor("#D8A462")
        radioGroup.titleColor = UIColor("#DAD9D7")
        radioGroup.titleFont = .systemFont(ofSize: 14, weight: .regular)
        radioGroup.spacing = 20
        radioGroup.itemSpacing = 12
        radioGroup.addTarget(self, action: #selector(optionSelected), for: .valueChanged)

        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with element: GraphElement, index: Int) {
        if let queries = element.queries, let query = queries[safe: index] {
            self.query = query

            numberLabel.text = "Question \(index + 1) of \(queries.count)"
            titleLabel.text = query.title
            radioGroup.titles = query.answers.map { $0.title }
        }
    }

    // MARK: - Private methods

    private func makeConstraints() {
        addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 12).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true

        addSubview(radioGroup)
        radioGroup.translatesAutoresizingMaskIntoConstraints = false
        radioGroup.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        radioGroup.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
        radioGroup.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        radioGroup.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }

    @objc
    private func optionSelected() {
        if let query = query, let answer = query.answers[safe: radioGroup.selectedIndex] {
            isPassed = query.correct == answer.id
        }
    }
}
