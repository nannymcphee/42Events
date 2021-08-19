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
    private let eventListResponse = BehaviorRelay<EventListResponse?>(value: nil)
    private let sectionList = BehaviorRelay<[EventListSection]>(value: [
        EventListSection(id: "startingSoon", title: Text.startingSoon,   data: []),
        EventListSection(id: "popular",      title: Text.popular,        data: []),
        EventListSection(id: "newRelease",   title: Text.newRelease,     data: []),
        EventListSection(id: "free",         title: Text.free,           data: []),
        EventListSection(id: "past",         title: Text.pastEvents,     data: []),
    ])
    private let featuredEvents = BehaviorRelay<[EventModel]>(value: [])
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
        Observable.combineLatest(input.slideshowSelected, self.eventListResponse)
            .compactMap { index, response -> Event? in
                guard let response = response, index <= response.featured.count else { return nil }
                return .presentEventDetail(response.featured[index])
            }
            .bind(to: self.eventPublisher)
            .disposed(by: disposeBag)
        
        return Output(featuredEvents: self.featuredEvents.asDriver(),
                      sections: self.sectionList.asDriver(),
                      loading: loading)
    }
    
    // MARK: Privates functions
    private func loadEvents() {
        eventsRepo
            .getAllEvents()
            .asObservable()
            .trackActivity(loadingIndicator)
            .subscribe(with: self, onNext: { viewModel, response in
                viewModel.eventListResponse.accept(response)
                // Featured
                viewModel.featuredEvents.accept(response.featured)
                
                // Starting soon, popular, New release, Free, Past events
                let mirror = Mirror(reflecting: response)
                var tempSections = viewModel.sectionList.value
                let mirrorChildren = mirror.children.filter { $0.label != "id" && $0.label != "updatedAt" && $0.label != "featured" }
                for child in mirrorChildren {
                    if let index = tempSections.firstIndex(where: { $0.id == child.label }) {
                        var temp = tempSections.remove(at: index)
                        temp.data = child.value as! [EventModel]
                        tempSections.insert(temp, at: index)
                    }
                }
                viewModel.sectionList.accept(tempSections)
            })
            .disposed(by: disposeBag)
    }
}
