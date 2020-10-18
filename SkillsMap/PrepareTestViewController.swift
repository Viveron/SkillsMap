//
//  PrepareTestViewController.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 18.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit
import KRProgressHUD

class PrepareTestViewController: UIViewController {

    let titleLabel = UILabel()
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    var element: GraphElement?

    var testViews: [TestView] = []
    var index: Int = 0

    let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#171717")

        titleLabel.textColor = UIColor("#DAD9D7")
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0

        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.spacing = 0

        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false

        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.borderWidth = 2
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderColor = UIColor("#D8A462").cgColor
        nextButton.setTitleColor(UIColor("#D8A462"), for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        nextButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func configure(with element: GraphElement) {
        self.element = element
        titleLabel.text = element.leaf.name

        let count = element.queries?.count ?? 0
        (0..<count).forEach { index in
            let testView = TestView()
            testViews.append(testView)
            testView.configure(with: element, index: index)
            stackView.addArrangedSubview(testView)
            testView.translatesAutoresizingMaskIntoConstraints = false
            testView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }

    @objc
    private func tapButton() {
        if index == testViews.count - 1 {
            var passed: Int = 0
            testViews.forEach { view in
                if view.isPassed {
                    passed += 1
                }
            }

            let total = passed > 0 ? Int(Double(passed) / Double(testViews.count) * 100) : 0
            let alert = UIAlertController(title: "Test completed!", message: "You score: \(total) of 100", preferredStyle: .alert)
            alert.addAction(.init(title: "Done", style: .default, handler: { _ in
                if total > 0, let element = self.element {
                    KRProgressHUD.show()
                    RateService.shared.update(value: total, for: element.leaf.id) {
                        KRProgressHUD.dismiss()
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }))

            present(alert, animated: true, completion: nil)

        } else {
            index += 1

            var frame = scrollView.frame
            frame.origin.x = frame.size.width * CGFloat(index)
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
}
