//
//  EventsApi.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import Foundation

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
    
    public func getEvents(sportType: String, limit: Int = 10, completion: @escaping (Result<[Event], Error>) -> Void) {
        let eventsManager = XNetworkManager<EventEndPoint>()
        eventsManager.request(target: .filterEvents(sportType: sportType, limit: limit)) { (result: XResult<[Event]>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
