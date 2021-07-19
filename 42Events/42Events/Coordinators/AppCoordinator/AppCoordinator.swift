//
//  AppCoordinator.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case events(StrongRouter<EventsRoute>)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    // MARK: Initialization
    init() {
        super.init(initialRoute: .events(EventsCoordinator().strongRouter))
    }
    
    // MARK: Overrides
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .events(let router):
            return .presentFullScreen(router)
        }
    }
}
