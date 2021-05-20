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
        NetworkManager.shared.get(NetworkRouter.raceEvents, parameters: nil) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                   let response = try? JSONDecoder().decode(RaceEventsResponse.self, from: jsonData) {
                    let eventListResponse = response.data
                    completion(.success(eventListResponse))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    public func getEvents(sportType: String, limit: Int = 10, completion: @escaping (Result<[Event], Error>) -> Void) {
        let parameters: [String: Any] = [
            "sportType": sportType,
            "limit": limit,
            "skipCount": 0,
        ]
        
        NetworkManager.shared.get(NetworkRouter.raceFilter, parameters: parameters) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                   let response = try? JSONDecoder().decode(EventFilterResponse.self, from: jsonData) {
                    completion(.success(response.data))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
