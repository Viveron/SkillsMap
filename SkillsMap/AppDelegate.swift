//
//  AppDelegate.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let root = ViewController()
        let navigation = UINavigationController(rootViewController: root)
        navigation.setBlackColors()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor("#171717")
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()

        return true
    }
}

extension UINavigationController {

    public func setBlackColors() {
        view.backgroundColor = UIColor("#171717")
        navigationBar.barTintColor = UIColor("#171717")
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
        UIApplication.shared.statusBarStyle = .default
    }
}
