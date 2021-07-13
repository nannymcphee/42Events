//
//  Event.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

struct EventModel: Codable {
    let id: String
    let raceIDs: [String]
    let slug, raceName: String
    let startDate, endDate: String
    let raceType: String
    let sportType: SportType
    let medalEngravingEndDate: String?
    let raceRunners: Int
    let launchDate: String
    let isNew, isFreeEngraving: Bool
    let racePeriod: String
    let categories: [String]?
    let racePrice: String?
    let eventType: EventType
    let bannerCard, medalViewImage: String
    let isBundle: Bool
    let brandRaceSlug: String
    let isBrandRace, joined: Bool
    
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
    
    /*
     sportType
     raceRunners
     racePrice
     categories
     eventType
     */
    public func getAllTags() -> [EventTag] {
        var allTags: [EventTag] = [
            EventTag(title: sportType.rawValue.capitalizeFirst, iconName: sportType.iconName),
        ]
        
        if raceRunners >= 1 {
            allTags.append(EventTag(title: "\(raceRunners) \(Text.joined.localized)"))
        }
        
        if let price = racePrice {
            let racePriceTag = EventTag(title: price)
            allTags.append(racePriceTag)
        }
        
        let categoriesTags = categories?.compactMap { EventTag(title: $0) }
        allTags.append(contentsOf: categoriesTags ?? [])
        
        let eventTypeTag = EventTag(title: eventType.displayName)
        allTags.append(eventTypeTag)
        
        return allTags
    }
}

enum EventType: String, Codable {
    case multiple = "multiple"
    case single = "single"
    
    var displayName: String {
        switch self {
        case .multiple:
            return Text.multipleSubmission
        case .single:
            return Text.singleSubmission
        }
    }
}

enum SportType: String, Codable {
    case cycling = "cycling"
    case running = "running"
    case walking = "walking"
    
    var iconName: String {
        switch self {
        case .cycling:
            return "ic_tag_cycling"
        case .walking:
            return "ic_tag_walking"
        case .running:
            return "ic_tag_running"
        }
    }
}
