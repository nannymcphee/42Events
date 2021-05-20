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
}
