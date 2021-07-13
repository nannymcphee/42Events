//
//  EventsVM.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift
import RxCocoa

class EventsVM: BaseVM, ViewModelType, EventPublisherType {
    
    // MARK: Inputs
    struct Input {
        let initialLoad: Observable<Void>
        let refresh: Observable<Void>
        let settingSelected: Observable<Void>
        let sportTypeSelected: Observable<String>
        let itemSelected: Observable<EventModel>
        let slideshowSelected: Observable<Int>
    }
    
    // MARK: Outputs
    struct Output {
        let featuredEvents: Driver<[EventModel]>
        let sections: Driver<[EventSection]>
        let loading: Driver<Bool>
    }
    
    // MARK: Event
    enum Event {
        case settings
        case filterEvents(String)
        case presentEventDetail(EventModel)
    }
    
    
    // MARK: Public variables
    public var eventPublisher = PublishSubject<Event>()
    
    
    // MARK: Private variables
    private let eventsApi = EventsApi.shared
    private var eventListResponse: EventListResponse? = nil
    private var sectionList = BehaviorRelay<[EventSection]>(value: [
        EventSection(id: "startingSoon", title: Text.startingSoon,   data: []),
        EventSection(id: "popular",      title: Text.popular,        data: []),
        EventSection(id: "newRelease",   title: Text.newRelease,     data: []),
        EventSection(id: "free",         title: Text.free,           data: []),
        EventSection(id: "past",         title: Text.pastEvents,     data: []),
    ])
    private var featuredEvents = BehaviorRelay<[EventModel]>(value: [])
    
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
        
        // Settings selected
        input.settingSelected
            .do(onNext: { [weak self] _ in
                self?.eventPublisher.onNext(.settings)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Event selected
        input.itemSelected
            .do(onNext: { [weak self] event in
                self?.eventPublisher.onNext(.presentEventDetail(event))
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Sport type selected
        input.sportTypeSelected
            .do(onNext: { [weak self] sportType in
                self?.eventPublisher.onNext(.filterEvents(sportType))
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Slideshow selected
        input.slideshowSelected
            .subscribe(onNext: { [weak self] index in
                guard let self = self, let response = self.eventListResponse else { return }
                let featuredEvent = response.featured[index]
                self.eventPublisher.onNext(.presentEventDetail(featuredEvent))
            })
            .disposed(by: disposeBag)
        
        return Output(featuredEvents: self.featuredEvents.asDriver(),
                      sections: self.sectionList.asDriver(),
                      loading: loading)
    }
    
    @discardableResult
    private func loadEvents() -> Observable<Void> {
        return eventsApi
            .getAllEventsRx()
            .asObservable()
            .do { [weak self] (response) in
                guard let self = self else { return }
                self.eventListResponse = response
                // Featured
                self.featuredEvents.accept(response.featured)
                
                // Starting soon, popular, New release, Free, Past events
                let mirror = Mirror(reflecting: response)
                var tempSections = self.sectionList.value
                let mirrorChildren = mirror.children.filter { $0.label != "id" && $0.label != "updatedAt" && $0.label != "featured" }
                for child in mirrorChildren {
                    if let index = tempSections.firstIndex(where: { $0.id == child.label }) {
                        var temp = tempSections.remove(at: index)
                        temp.data = child.value as! [EventModel]
                        tempSections.insert(temp, at: index)
                    }
                }
                self.sectionList.accept(tempSections)
        }
        .mapToVoid()
            
    }
    
    // MARK: Privates functions
}
