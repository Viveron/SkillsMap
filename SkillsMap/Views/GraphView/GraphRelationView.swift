//
//  GraphRelationView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

final class GraphRelationView: UIView {

    var elementState: GraphElement.State = .default {
        didSet {
            layer.opacity = elementState  == .hidden ? 0.5 : 1.0
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        switch elementState {
        case .selected:
            UIColor("#DAD9D7").setStroke()

        default:
            UIColor("#6C6874").setStroke()
        }

        path.lineWidth = Constants.lineWidth
        path.move(to: .zero)

        let arcY = rect.height - Constants.cornerRadius
        path.addLine(to: CGPoint(x: 0, y: arcY))

        let arcCenter = CGPoint(x: Constants.cornerRadius, y: arcY)
        path.addArc(withCenter: arcCenter,
                    radius: Constants.cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi/2,
                    clockwise: false)

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.stroke()
    }
}

// MARK: - Constants
extension GraphRelationView {

    private enum Constants {

        static let lineWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 7
    }
}
