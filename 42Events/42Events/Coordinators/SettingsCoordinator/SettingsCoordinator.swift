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
    enum Event {
        case releaseIfNeeded
    }
    
    // MARK: Initialization
    
    public init(navigation: UINavigationController? = nil) {
        let nav = navigation ?? UINavigationController()
        super.init(rootViewController: nav, initialRoute: nil)
        trigger(.main)
    }
    
    public let eventPublisher = PublishSubject<Event>()
    private let disposeBag = DisposeBag()
    
    // MARK: Overrides
    
    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .main:
            let vc = SettingsVC.instance()
            let vm = SettingsVM()
            
            vm.eventPublisher
                .subscribe(onNext: { [weak self] event in
                    guard let self = self else { return }
                    
                    switch event {
                    case .releaseIfNeeded:
                        self.eventPublisher.onNext(.releaseIfNeeded)
                    }
                })
                .disposed(by: disposeBag)
            
            vc.bind(to: vm)
            return .push(vc)
        }
    }
}
