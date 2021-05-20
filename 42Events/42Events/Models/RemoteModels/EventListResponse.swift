//
//  EventListResponse.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import Foundation

struct RaceEventsResponse: Codable {
    let code: Int
    let data: EventListResponse
}

struct EventListResponse: Codable {
    let featured, startingSoon, popular: [Event]
    let newRelease, free, past: [Event]
    let id, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case featured, startingSoon, popular, newRelease, free, past
        case id = "_id"
        case updatedAt
    }
}