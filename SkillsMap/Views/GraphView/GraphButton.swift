//
//  GraphButton.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

final class GraphButton: UIButton {

    private let badgeImageView = UIImageView()

    var elementState: GraphElement.State = .default {
        didSet {
            updateStyle()
        }
    }

    var isLeaf: Bool = false {
        didSet {
            badgeImageView.isHidden = !isLeaf
        }
    }

    var badgeImage: UIImage? {
        didSet {
            badgeImageView.image = badgeImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.opacity = 1
        layer.borderWidth = 2
        layer.cornerRadius = 4
        contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)

        setTitleColor(UIColor("#DAD9D7"), for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        semanticContentAttribute = .forceRightToLeft
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)

//        let size = CGSize(width: 10, height: 10)
//        addSubview(badgeImageView)
//        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
//        badgeImageView.topAnchor.constraint(equalTo: topAnchor, constant: -size.height/3).isActive = true
//        badgeImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: size.width/3).isActive = true
//        badgeImageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
//        badgeImageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        badgeImageView.transform = .init(scaleX: 3, y: 3)

        updateStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func updateStyle() {
        let color: UIColor
        switch elementState {
        case .hidden:
            color = UIColor("#6C6874")
            layer.opacity = 0.5
            badgeImageView.layer.opacity = 0.5

        case .selected:
            color = UIColor("#DAD9D7")
            layer.opacity = 1
            badgeImageView.layer.opacity = 1

        default:
            color = UIColor("#6C6874")
            layer.opacity = 1
            badgeImageView.layer.opacity = 1
        }
        layer.borderColor = color.cgColor

        if isLeaf {
            setTitleColor(UIColor("#D8A462"), for: .highlighted)
            setImage(UIImage(named: "arrow-right"), for: .normal)
        }

        setNeedsDisplay()
    }
}
