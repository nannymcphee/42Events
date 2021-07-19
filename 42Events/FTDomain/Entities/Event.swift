//
//  Event.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

public struct EventModel: Codable {
    public let id: String
    public let raceIDs: [String]
    public let slug, raceName: String
    public let startDate, endDate: String
    public let raceType: String
    public let sportType: SportType
    public let medalEngravingEndDate: String?
    public let raceRunners: Int
    public let launchDate: String
    public let isNew, isFreeEngraving: Bool
    public let racePeriod: String
    public let categories: [String]?
    public let racePrice: String?
    public let eventType: EventType
    public let bannerCard, medalViewImage: String
    public let isBundle: Bool
    public let brandRaceSlug: String
    public let isBrandRace, joined: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case raceIDs, slug
        case raceName = "race_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case raceType = "race_type"
        case sportType
        case medalEngravingEndDate = "medal_engraving_end_date"
        case raceRunners
        case launchDate = "launch_date"
        case isNew = "is_new"
        case isFreeEngraving, racePeriod, categories, racePrice, eventType
        case bannerCard = "banner_card"
        case medalViewImage, isBundle, brandRaceSlug
        case isBrandRace = "is_brand_race"
        case joined
    }
    
    public init() {
        id = ""
        raceIDs = []
        slug = ""
        raceName = ""
        startDate = ""
        endDate = ""
        raceType = ""
        sportType = .cycling
        medalEngravingEndDate = nil
        raceRunners = 0
        launchDate = ""
        isNew = false
        isFreeEngraving = false
        racePeriod = ""
        categories = nil
        racePrice = ""
        eventType = .single
        bannerCard = ""
        medalViewImage = ""
        isBundle = false
        brandRaceSlug = ""
        isBrandRace = false
        joined = false
    }
}

public enum EventType: String, Codable {
    case multiple = "multiple"
    case single = "single"
}

public enum SportType: String, Codable {
    case cycling = "cycling"
    case running = "running"
    case walking = "walking"
}
