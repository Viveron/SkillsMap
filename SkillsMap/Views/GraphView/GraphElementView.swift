//
//  GraphElementView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

final class GraphElementView: UIView {

    private(set) var elementsViews: [GraphElementView] = []
    private(set) var relationsViews: [GraphRelationView] = []

    let titleButton = GraphButton()

    var selectClosure: ValueClosure<GraphElement>? {
        didSet {
            elementsViews.forEach {
                $0.selectClosure = selectClosure
            }
        }
    }

    var element: GraphElement? {
        didSet {
            updateViews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleButton.isHidden = true
        titleButton.addTarget(self, action: #selector(tapAction), for: .touchUpInside)

        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reload() {
        updateButton()

        elementsViews.forEach {
            $0.updateButton()
        }
    }

    // MARK: - Private methods

    private func makeConstraints() {
        addSubview(titleButton)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.setContentHuggingPriority(.required, for: .horizontal)
        titleButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleButton.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        titleButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
    }

    private func clearViews() {
        elementsViews.forEach {
            $0.removeFromSuperview()
        }
        elementsViews = []

        relationsViews.forEach {
            $0.removeFromSuperview()
        }
        relationsViews = []
    }

    private func updateViews() {
        clearViews()
        reload()

        guard let element = element else {
            return
        }

        if let elements = element.elements {
            var elementViewBottomAnchor = titleButton.bottomAnchor

            elements.forEach { element in
                let elementView = GraphElementView()
                elementView.selectClosure = selectClosure
                elementsViews.append(elementView)
                elementView.element = element

                addSubview(elementView)
                elementView.translatesAutoresizingMaskIntoConstraints = false
                elementView.topAnchor.constraint(equalTo: elementViewBottomAnchor, constant: Constants.insets.top).isActive = true
                elementView.leftAnchor.constraint(equalTo: titleButton.centerXAnchor, constant: Constants.insets.left).isActive = true
                elementView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
                elementView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
                elementViewBottomAnchor = elementView.bottomAnchor

                let relationView = GraphRelationView()
                relationView.elementState = element.state
                relationsViews.append(relationView)

                addSubview(relationView)
                relationView.translatesAutoresizingMaskIntoConstraints = false
                relationView.topAnchor.constraint(equalTo: titleButton.bottomAnchor).isActive = true
                relationView.leftAnchor.constraint(equalTo: titleButton.centerXAnchor).isActive = true
                relationView.bottomAnchor.constraint(equalTo: elementView.titleButton.centerYAnchor).isActive = true
                relationView.widthAnchor.constraint(equalToConstant: Constants.insets.left).isActive = true
            }
        }

        needsUpdateConstraints()
        updateConstraintsIfNeeded()
    }

    private func updateButton() {
        guard let element = element else {
            titleButton.isHidden = true
            return
        }

        titleButton.setTitle(element.leaf.name, for: .normal)
        titleButton.isHidden = false
        titleButton.isLeaf = element.isLeaf
        titleButton.elementState = element.state

        if (element.leaf.require ?? 0) == 1 {
            titleButton.badgeImage = UIImage(named: "warning-icon")
        } else {
            titleButton.badgeImage = nil
        }

        relationsViews.forEach {
            $0.elementState = element.state
        }
    }

    // MARK: - Actions

    @objc
    private func tapAction() {
        if let element = element {
            selectClosure?(element)
        }
    }
}

// MARK: - Constants
extension GraphElementView {

    private enum Constants {

        static let insets = UIEdgeInsets(top: 15, left: 40, bottom: 0, right: 0)
    }
}
