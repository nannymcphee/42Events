//
//  EventsFilterVM.swift
//  42Events
//
//  Created by Duy Nguyen on 18/06/2021.
//

import RxSwift
import RxCocoa
import Resolver
import FTDomain

class EventsFilterVM: BaseVM, ViewModelType, EventPublisherType {
    // MARK: - Initialization
    init(sportType: String) {
        self.sportType = sportType
    }
    
    // MARK: Inputs
    struct Input {
        let initialLoad: Observable<Void>
        let networkConnectionRestored: Observable<Void>
        let refresh: Observable<Void>
        let medalViewToggle: Observable<Bool>
        let itemSelected: Observable<EventModel>
    }
    
    // MARK: Outputs
    struct Output {
        let events: Driver<[EventModel]>
        let isMedalView: Driver<Bool>
        let loading: Driver<Bool>
    }
    
    // MARK: Event
    enum Event {
        case presentEventDetail(EventModel)
    }
    
    // MARK: Public variables
    public var eventPublisher = PublishSubject<Event>()
    public var sportType: String
    
    // MARK: Private variables
    @Injected private var eventsRepo: EventsRepo
    private let eventListResponse: EventListResponse? = nil
    private let events = BehaviorRelay<[EventModel]>(value: [])
    private let isMedalView = BehaviorRelay<Bool>(value: false)
    private let loadingIndicator = ActivityIndicator()

    // MARK: Public functions
    func transform(input: Input) -> Output {
        let loading = loadingIndicator.asDriver()
        
        // Load list events & Pull to refresh
        Observable.merge(input.initialLoad, input.refresh)
            .subscribe(with: self, onNext: { viewModel, _ in
                viewModel.loadEvents()
            })
            .disposed(by: disposeBag)
        
        // Medal view toggled
        input.medalViewToggle
            .bind(to: isMedalView)
            .disposed(by: disposeBag)
        
        // Event selected
        input.itemSelected
            .map { Event.presentEventDetail($0) }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        return Output(events: events.asDriver(),
                      isMedalView: isMedalView.asDriver(),
                      loading: loading)
    }
    
    // MARK: Privates functions
    private func loadEvents() {
        eventsRepo
            .getEvents(sportType: sportType, limit: 10)
            .trackActivity(loadingIndicator)
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }
}
