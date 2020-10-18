//
//  ChartView.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit
import ScrollableGraphView

class ChartView: UIView {

    private var skills: [Skill] = []
    private var filter: [String] = []
    private var filtered: [Skill] = [] // для дефолтного отображения

    lazy var graphView = {
        ScrollableGraphView(frame: self.frame, dataSource: self)
    }()

    let legendStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let linePlot = LinePlot(identifier: "darkLine")

        linePlot.lineWidth = 2
        linePlot.lineColor = UIColor("#DAD9D7")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth

        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor("#6C6874", alpha: 0.7)
        linePlot.fillGradientEndColor = UIColor("#6C6874", alpha: 0.1)

        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let dotPlot = DotPlot(identifier: "darkLineDot")
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = UIColor("#D8A462", alpha: 0.9)

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic


        let referenceLines = ReferenceLines()

        referenceLines.referenceLineLabelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        referenceLines.referenceLineColor = UIColor("#797988", alpha: 0.67)
        referenceLines.referenceLineLabelColor = UIColor("#919195")

        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [25, 50, 75]
        referenceLines.includeMinMax = true

        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

        graphView.showsHorizontalScrollIndicator = false
        graphView.backgroundFillColor = UIColor.clear
        graphView.dataPointSpacing = 55

        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true

        graphView.topMargin = 15
        graphView.shouldAdaptRange = false
        graphView.rangeMax = 100
        graphView.rangeMin = 0

        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)

        legendStackView.axis = .horizontal
        legendStackView.alignment = .fill
        legendStackView.distribution = .equalSpacing
        legendStackView.spacing = 25

        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func update(skills: [Skill]) {
        self.skills = skills
        filter(ids: filter)
    }

    func filter(ids: [String] = []) {
        filter = ids

        if ids.isEmpty {
            filtered = skills
        } else {
            filtered = skills.filter {
                ids.contains($0.id)
            }
        }

        DispatchQueue.main.async {
            self.graphView.reload()
        }
    }

    // MARK: - Private methods

    private func makeConstraints() {
        addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        graphView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        graphView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        graphView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true

        addSubview(legendStackView)
        legendStackView.translatesAutoresizingMaskIntoConstraints = false
        legendStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        legendStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true

        let lineLegendView = ChartLegendView()
        lineLegendView.nameLabel.text = "General Distillery rate"
        lineLegendView.plotView.kind = .line

        let dotLegendView = ChartLegendView()
        dotLegendView.nameLabel.text = "Your result"
        dotLegendView.plotView.kind = .dot

        legendStackView.addArrangedSubview(lineLegendView)
        legendStackView.addArrangedSubview(dotLegendView)
    }
}

extension ChartView: ScrollableGraphViewDataSource {

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if plot.identifier == "darkLine" {
            return Double(filtered[safe: pointIndex]?.total ?? -100)
        }
        if plot.identifier == "darkLineDot" {
            let value = Double(filtered[safe: pointIndex]?.user ?? -100)
            return value > 0 ? value : -100
        }
        return -100
    }

    func label(atIndex pointIndex: Int) -> String {
        return "."
    }

    func numberOfPoints() -> Int {
        return filtered.count
    }
}
