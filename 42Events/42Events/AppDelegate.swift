//
//  AppDelegate.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import SwipeBack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: SwipeBackNavigationController?
    var rootViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setUpRootVC()
        return true
    }
    
    private func setUpRootVC() {
        let eventsVC = EventsVC()
        rootViewController = eventsVC
        navigationController = SwipeBackNavigationController(rootViewController: rootViewController!)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


}

