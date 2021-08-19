//
//  EventListResponse.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import Foundation

public struct EventListResponse: Codable {
    public let featured, startingSoon, popular: [EventModel]
    public let newRelease, free, past: [EventModel]
    public let id, updatedAt: String
    
    public init() {
        self.featured = []
        self.startingSoon = []
        self.popular = []
        self.newRelease = []
        self.free = []
        self.past = []
        self.id = ""
        self.updatedAt = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case featured, startingSoon, popular, newRelease, free, past
        case id = "_id"
        case updatedAt
    }
}
