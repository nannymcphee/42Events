//
//  EventsCoordinator.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift
import XCoordinator
import FTDomain

enum EventsRoute: Route {
    case events
    case eventDetail(EventModel)
    case filterEvents(String)
    case settings
}

class EventsCoordinator: NavigationCoordinator<EventsRoute> {
    // MARK: Initialization
    init() {
        super.init(initialRoute: .events)
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: Overrides
    override func prepareTransition(for route: EventsRoute) -> NavigationTransition {
        switch route {
        case .events:
            let vc = EventsVC.instantiate()
            let viewModel = EventsVM()
            vc.bind(to: viewModel)
            
            viewModel.eventPublisher
                .subscribe(onNext: { [weak self] event in
                    guard let self = self else { return }
                    switch event {
                    case .presentEventDetail(let model):
                        self.trigger(.eventDetail(model))
                    case .settings:
                        self.trigger(.settings)
                    case .filterEvents(let sportType):
                        self.trigger(.filterEvents(sportType))
                    }
                })
                .disposed(by: disposeBag)
            
            return .push(vc)
            
        case .eventDetail(let event):
            let vc = EventDetailVC.instance()
            let vm = EventDetailVM(eventModel: event)
            vc.bind(to: vm)
            
            let nav = UINavigationController(rootViewController: vc)
    
            return .present(nav)
        
        case .filterEvents(let sportType):
            let vc = EventsFilterVC.instance()
            let vm = EventsFilterVM(sportType: sportType)
            vc.bind(to: vm)
            
            vm.eventPublisher
                .subscribe(onNext: { [weak self] event in
                    guard let self = self else { return }
                    switch event {
                    case .presentEventDetail(let event):
                        self.trigger(.eventDetail(event))
                    }
                })
                .disposed(by: disposeBag)
            
            let nav = UINavigationController(rootViewController: vc)
            return .present(nav)
        
        case .settings:
            let settingsCoordinator = SettingsCoordinator(navigation: rootViewController)
            addChild(settingsCoordinator)
            return .none()
        }
    }
}
