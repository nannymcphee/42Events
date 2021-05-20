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
    let featured, startingSoon, popular, newRelease: [Event]
    let free, past: [Event]
    let id, updatedAt: String
    
    var presentableData: [[Event]] = []
    
    enum CodingKeys: String, CodingKey {
        case featured, startingSoon, popular, newRelease, free, past
        case id = "_id"
        case updatedAt
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = values.decodex(key: .id, defaultValue: "")
        updatedAt = values.decodex(key: .updatedAt, defaultValue: "")
        featured = values.decodex(key: .featured, defaultValue: [])
        startingSoon = values.decodex(key: .startingSoon, defaultValue: [])
        popular = values.decodex(key: .popular, defaultValue: [])
        newRelease = values.decodex(key: .newRelease, defaultValue: [])
        free = values.decodex(key: .free, defaultValue: [])
        past = values.decodex(key: .past, defaultValue: [])
        presentableData = [featured, startingSoon, popular, newRelease, past]
    }
}
