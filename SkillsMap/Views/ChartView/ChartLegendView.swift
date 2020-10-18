//
//  ChartLegendView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

extension ChartLegendPlotView {

    enum Kind {
        case line
        case dot
    }
}

class ChartLegendPlotView: UIView {

    var kind: Kind = .line {
        didSet {
            updateBackgroundColor()
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        updateBackgroundColor()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let path: UIBezierPath

        if kind == .line {
            path = UIBezierPath()
            path.lineWidth = 2
            UIColor("#DAD9D7").setStroke()

            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.stroke()

        } else {
            path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2),
                                radius: rect.height/2,
                                startAngle: 0,
                                endAngle: .pi * 2,
                                clockwise: true)

            UIColor("#D8A462", alpha: 0.9).setFill()
            path.fill()
        }
    }

    func updateBackgroundColor() {
        if kind == .line {
            backgroundColor = UIColor("#6C6874", alpha: 0.3)
        } else {
            backgroundColor = .clear
        }
    }
}

class ChartLegendView: UIView {

    let plotView = ChartLegendPlotView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        nameLabel.textColor = UIColor("#919195")
        nameLabel.font = .systemFont(ofSize: 12, weight: .regular)

        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func makeConstraints() {
        addSubview(plotView)
        plotView.translatesAutoresizingMaskIntoConstraints = false
        plotView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        plotView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        plotView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        plotView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: plotView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
