//
//  EventListResponse.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import Foundation

struct EventListResponse: Codable {
    let featured, startingSoon, popular: [Event]
    let newRelease, free, past: [Event]
    let id, updatedAt: String
    
    init() {
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
