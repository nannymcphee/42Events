//
//  EventsRepo.swift
//  42Events
//
//  Created by Duy Nguyen on 13/07/2021.
//

import RxSwift

public protocol EventsRepo {
    func getAllEvents() -> Single<EventListResponse>
    func getEvents(sportType: String, limit: Int) -> Single<[EventModel]>
}

public class EventsRepoImpl: EventsRepo {
    public func getAllEvents() -> Single<EventListResponse> {
        return Single.create { (observer) -> Disposable in
            let eventsManager = XNetworkManager<EventEndPoint>()
            eventsManager.request(target: .getAllEvents) { (result: XResult<EventListResponse>) in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let err):
                    observer(.failure(err))
                }
            }
            return Disposables.create()
        }
    }
    
    public func getEvents(sportType: String, limit: Int) -> Single<[EventModel]> {
        return Single.create { (observer) -> Disposable in
            let eventsManager = XNetworkManager<EventEndPoint>()
            eventsManager.request(target: .filterEvents(sportType: sportType, limit: limit)) { (result: XResult<[EventModel]>) in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let err):
                    observer(.failure(err))
                }
            }
            return Disposables.create()
        }
    }
}
