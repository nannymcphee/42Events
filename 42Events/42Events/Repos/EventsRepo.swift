//
//  EventsRepo.swift
//  42Events
//
//  Created by Duy Nguyen on 13/07/2021.
//

import RxSwift
import Resolver
import FTDomain
import FTNetworkPlatform

public protocol EventsRepo {
    func getAllEvents() -> Single<EventListResponse>
    func getEvents(sportType: String, limit: Int) -> Single<[EventModel]>
}

public class EventsRepoImpl: EventsRepo {
    @Injected private var eventsApi: FTNetworkPlatform.EventUseCase
    
    public func getAllEvents() -> Single<EventListResponse> {
        return eventsApi.getAllEvents()
    }
    
    public func getEvents(sportType: String, limit: Int) -> Single<[EventModel]> {
        return eventsApi.getEvents(sportType: sportType, limit: limit)
    }
}
