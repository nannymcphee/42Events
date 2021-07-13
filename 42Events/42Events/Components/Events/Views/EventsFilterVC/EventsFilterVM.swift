//
//  EventsFilterVM.swift
//  42Events
//
//  Created by Duy Nguyen on 18/06/2021.
//

import RxSwift
import RxCocoa

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
    private let eventsApi = EventsApi.shared
    private var eventListResponse: EventListResponse? = nil
    private var events = BehaviorRelay<[EventModel]>(value: [])
    private var isMedalView = BehaviorRelay<Bool>(value: false)

    // MARK: Public functions
    func transform(input: Input) -> Output {
        let loadingIndicator = ActivityIndicator()
        let loading = loadingIndicator.asDriver()
        
        // Load list events
        input.initialLoad
            .flatMap { [weak self] () -> Observable<Void> in
                guard let self = self else { return .empty() }
                
                return self.loadEvents().trackActivity(loadingIndicator)
            }
            .catch({ (err) -> Observable<Void> in
                print("Load events failed: \(err.localizedDescription)")
                return .empty()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Refresh data
        input.refresh
            .flatMap { [weak self] () -> Observable<Void> in
                guard let self = self else { return .empty() }
                
                return self.loadEvents().trackActivity(loadingIndicator)
            }
            .catch({ (err) -> Observable<Void> in
                print("Load events failed: \(err.localizedDescription)")
                return .empty()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Medal view toggled
        input.medalViewToggle
            .bind(to: isMedalView)
            .disposed(by: disposeBag)
        
        return Output(events: events.asDriver(),
                      isMedalView: isMedalView.asDriver(),
                      loading: loading)
    }
    
    @discardableResult
    private func loadEvents() -> Observable<Void> {
        return eventsApi
            .getEventsRx(sportType: sportType)
            .asObservable()
            .do(onNext: { [weak self] response in
                guard let self = self else { return }
                self.events.accept(response)
            })
            .mapToVoid()
    }
    
    // MARK: Privates functions
}
