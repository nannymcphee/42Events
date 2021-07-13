//
//  EventsApi.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import RxSwift

class EventsApi {
    static var shared = EventsApi()
    
    public func getAllEvents(completion: @escaping (Result<EventListResponse, Error>) -> Void) {
        let eventsManager = XNetworkManager<EventEndPoint>()
        eventsManager.request(target: .getAllEvents) { (result: XResult<EventListResponse>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    public func getEvents(sportType: String, limit: Int = 10, completion: @escaping (Result<[EventModel], Error>) -> Void) {
        let eventsManager = XNetworkManager<EventEndPoint>()
        eventsManager.request(target: .filterEvents(sportType: sportType, limit: limit)) { (result: XResult<[EventModel]>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    public func getAllEventsRx() -> Single<EventListResponse> {
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
    
    public func getEventsRx(sportType: String, limit: Int = 10) -> Single<[EventModel]> {
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
