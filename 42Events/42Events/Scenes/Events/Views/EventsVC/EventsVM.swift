//
//  EventsVM.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift
import RxCocoa
import Resolver
import FTDomain

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
        let sections: Driver<[EventListSection]>
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
    @Injected private var eventsRepo: EventsRepo
    private var eventListResponse: EventListResponse? = nil
    private var sectionList = BehaviorRelay<[EventListSection]>(value: [
        EventListSection(id: "startingSoon", title: Text.startingSoon,   data: []),
        EventListSection(id: "popular",      title: Text.popular,        data: []),
        EventListSection(id: "newRelease",   title: Text.newRelease,     data: []),
        EventListSection(id: "free",         title: Text.free,           data: []),
        EventListSection(id: "past",         title: Text.pastEvents,     data: []),
    ])
    private var featuredEvents = BehaviorRelay<[EventModel]>(value: [])
    private let loadingIndicator = ActivityIndicator()
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        let loading = loadingIndicator.asDriver()
        
        // Load list events
        input.initialLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.loadEvents()
            }, onError: { err in
                print("Load events failed: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // Refresh data
        input.refresh
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.loadEvents()
            }, onError: { err in
                print("Load events failed: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // Settings selected
        input.settingSelected
            .map { Event.settings }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        // Event selected
        input.itemSelected
            .map { Event.presentEventDetail($0) }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        // Sport type selected
        input.sportTypeSelected
            .map { Event.filterEvents($0) }
            .bind(to: eventPublisher)
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
    
    private func loadEvents() {
        eventsRepo
            .getAllEvents()
            .asObservable()
            .trackActivity(loadingIndicator)
            .subscribe(onNext: { [weak self] response in
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
            })
            .disposed(by: disposeBag)
            
    }
    
    // MARK: Privates functions
}
