//
//  AppDelegate.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let router = AppCoordinator().strongRouter
    private lazy var mainWindow = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        router.setRoot(for: mainWindow)
        return true
    }

}

