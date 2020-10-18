//
//  GraphView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

final class GraphView: UIView {

    let scrollView = UIScrollView()

    let elementView = GraphElementView()

    var grapth: Graph? {
        didSet {
            elementView.element = grapth?.root
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor("#000000")
        scrollView.bounces = false

        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func makeConstraints() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        scrollView.addSubview(elementView)
        elementView.translatesAutoresizingMaskIntoConstraints = false
        elementView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.inset).isActive = true
        elementView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: Constants.inset).isActive = true
        elementView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -Constants.inset).isActive = true
        elementView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.inset).isActive = true
    }
}

// MARK: - Constants
extension GraphView {

    private enum Constants {

        static let inset: CGFloat = 25
    }
}
