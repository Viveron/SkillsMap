//
//  ViewController.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let graphView = GraphView()
    let chartView = ChartView()

    let graph = Mock.testGraph()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Skills map"

        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chartView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chartView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        graphView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        graphView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        graphView.grapth = graph
        graphView.elementView.selectClosure = { [weak self] element in
            guard let self = self else {
                return
            }

            if element.isLeaf {
                self.openTest(for: element)
            } else {
                self.graph?.root.state = .hidden
                element.state = element.isRoot ? .default : .selected
                self.graphView.elementView.reload()

                if element.isRoot {
                    self.chartView.filter(ids: [])
                } else {
                    if let path = self.graph?.skillsIdsPath(by: element) {
                        self.chartView.filter(ids: path)
                    } else {
                        self.chartView.filter(ids: [])
                    }
                }
            }
        }

        updateSkills()
    }

    private func openTest(for element: GraphElement) {
        let controller = PrepareTestViewController()
        controller.configure(with: element)

        navigationController?.pushViewController(controller, animated: true)
    }

    private func updateSkills() {
        let rate = Mock.testRate()

        var skils: [Skill] = []
        if let graph = graph {
            let path = graph.skillsIdsPath(by: graph.root)

            path.forEach { id in
                if let skill = rate?.skills.first(where: { $0.id == id }) {
                    skils.append(skill)
                }
            }
        }

        chartView.update(skills: skils)
    }
}
