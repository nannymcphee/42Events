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
    private var eventListResponse: EventListResponse? = nil
    private var events = BehaviorRelay<[EventModel]>(value: [])
    private var isMedalView = BehaviorRelay<Bool>(value: false)
    private let loadingIndicator = ActivityIndicator()

    // MARK: Public functions
    func transform(input: Input) -> Output {
        let loading = loadingIndicator.asDriver()
        
        // Load list events
        input.initialLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.loadEvents()
            }, onError: { (err) in
                print("Load events failed: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // Refresh data
        input.refresh
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.loadEvents()
            }, onError: { (err) in
                print("Load events failed: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // Medal view toggled
        input.medalViewToggle
            .bind(to: isMedalView)
            .disposed(by: disposeBag)
        
        return Output(events: events.asDriver(),
                      isMedalView: isMedalView.asDriver(),
                      loading: loading)
    }
    
    private func loadEvents() {
        eventsRepo
            .getEvents(sportType: sportType, limit: 10)
            .asObservable()
            .trackActivity(loadingIndicator)
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }
    
    // MARK: Privates functions
}
