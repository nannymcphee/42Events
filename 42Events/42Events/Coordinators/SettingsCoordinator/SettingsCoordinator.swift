//
//  SettingsCoordinator.swift
//  42Events
//
//  Created by Duy Nguyen on 19/07/2021.
//

import RxSwift
import XCoordinator

enum SettingsRoute: Route {
    case main
}

class SettingsCoordinator: NavigationCoordinator<SettingsRoute> {
    
    // MARK: Initialization
    
    public init(navigation: UINavigationController? = nil) {
        let nav = navigation ?? UINavigationController()
        super.init(rootViewController: nav, initialRoute: nil)
        trigger(.main)
    }
    
    deinit {
        print(">>>>>>> Deinit SettingsCoordinator <<<<<<<<<<")
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: Overrides
    
    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .main:
            let vc = SettingsVC.instance()
            return .push(vc)
        }
    }
}
