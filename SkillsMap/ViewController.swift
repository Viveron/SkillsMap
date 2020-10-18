//
//  ViewController.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit
import KRProgressHUD

class ViewController: UIViewController {

    var isDarkContentBackground = false

    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        setNeedsStatusBarAppearanceUpdate()
    }

    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        } else {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
    }

    let graphView = GraphView()
    let chartView = ChartView()

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

        statusBarEnterDarkBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserService.roadmapId.isEmpty {
            let controller = UIAlertController(title: "Hi!", message: "Select you department", preferredStyle: .alert)
            controller.addAction(.init(title: "HR", style: .default, handler: { _ in
                UserService.roadmapId = "HR-0"
                self.loadRoadMap()
            }))
            controller.addAction(.init(title: "QA", style: .default, handler: { _ in
                UserService.roadmapId = "QA-0"
                self.loadRoadMap()
            }))
            present(controller, animated: true, completion: nil)
        } else {
            loadRoadMap()
        }
    }

    private func openTest(for element: GraphElement) {
        let controller = PrepareTestViewController()
        controller.configure(with: element)

        navigationController?.pushViewController(controller, animated: true)
    }

    private func updateSkills() {
        let rate = RateService.shared.rate

        var skils: [Skill] = []
        if let graph = UserService.shared.grapth {
            let path = graph.skillsIdsPath(by: graph.root)

            path.forEach { id in
                if let skill = rate?.skills.first(where: { $0.id == id }) {
                    skils.append(skill)
                }
            }
        }

        chartView.update(skills: skils)
    }

    func loadRoadMap() {
        KRProgressHUD.show()

        RateService.shared.updateClosure = {
            if UserService.shared.grapth == nil {
                KRProgressHUD.showError()
            } else {
                KRProgressHUD.dismiss()
            }
            self.reload()
        }

        UserService.shared.updateClosure = {
            if UserService.shared.grapth == nil {
                KRProgressHUD.showError()
            } else {
                RateService.shared.load()
                //RateService.shared.mockLoad()
            }
        }

        UserService.shared.load()
        //UserService.shared.mockLoad()
    }

    func reload() {
        graphView.grapth = UserService.shared.grapth
        graphView.elementView.selectClosure = { [weak self] element in
            guard let self = self else {
                return
            }

            if element.isLeaf {
                self.openTest(for: element)
            } else {
                UserService.shared.grapth?.root.state = .hidden
                element.state = element.isRoot ? .default : .selected
                self.graphView.elementView.reload()

                if element.isRoot {
                    self.chartView.filter(ids: [])
                } else {
                    if let path = UserService.shared.grapth?.skillsIdsPath(by: element) {
                        self.chartView.filter(ids: path)
                    } else {
                        self.chartView.filter(ids: [])
                    }
                }
            }
        }

        updateSkills()
    }
}

import KeychainAccess

class UserService {

    static let shared = UserService()

    static var roadmapId: String = ""

    let session = URLSession(configuration: .default)

    let keychain = Keychain(service: "com.vshabanov.skillsmap")

    let udid: String

    var updateClosure: VoidClosure? = nil

    var grapth: Graph?

    init() {
        if let stored = try? keychain.getString("uuid") {
            udid = stored
        } else {
            udid = UUID().uuidString
            try? keychain.set(udid, key: "uuid")
        }
    }

    func load() {
        var reguest = URLRequest(url: URL(string: "\(String.dedugURL)/roadmap/\(UserService.roadmapId)")!)
        reguest.httpMethod = "GET"

        let tack = session.dataTask(with: reguest) { (data, _, _) in
            if let data = data {
                do {
                    let roadmap = try JSONDecoder().decode(Roadmap.self, from: data)
                    let grapth = GraphBuilder().buildGraph(from: roadmap)

                    self.grapth = grapth
                } catch {
                    if error.localizedDescription.isEmpty {

                    }
                }
            }

            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }

        tack.resume()
    }

    func mockLoad() {
        grapth = Mock.testGraph()

        DispatchQueue.main.async {
            self.updateClosure?()
        }
    }
}

class RateService {

    static let shared = RateService()

    let session = URLSession(configuration: .default)

    var updateClosure: VoidClosure? = nil

    var rate: Rate?

    func load() {
        var reguest = URLRequest(url: URL(string: "\(String.dedugURL)/\(UserService.shared.udid)/\(UserService.roadmapId)")!)
        reguest.httpMethod = "GET"

        let tack = session.dataTask(with: reguest) { (data, _, _) in
            if let data = data {
                do {
                    self.rate = try JSONDecoder().decode(Rate.self, from: data)
                } catch {
                    if error.localizedDescription.isEmpty {

                    }
                }
            }

            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }

        tack.resume()
    }

    func update(value: Int, for key: String, closure: VoidClosure? = nil) {
        var reguest = URLRequest(url: URL(string: "\(String.dedugURL)/\(UserService.shared.udid)/\(UserService.roadmapId)/\(key)?stat_value=\(value)")!)
        reguest.httpMethod = "POST"

        let tack = session.dataTask(with: reguest) { (data, _, _) in
            if let data = data {
                do {
                    self.rate = try JSONDecoder().decode(Rate.self, from: data)
                } catch {
                    if error.localizedDescription.isEmpty {

                    }
                }
            }

            DispatchQueue.main.async {
                closure?()
            }
        }

        tack.resume()
    }

    func mockLoad() {
        rate = Mock.testRate()

        DispatchQueue.main.async {
            self.updateClosure?()
        }
    }
}

extension String {

    static let dedugURL = "https://b30d5e37e3f5.ngrok.io"
    static let releaseURL = "https://hrizator3000.pg.distillery.com"
}
