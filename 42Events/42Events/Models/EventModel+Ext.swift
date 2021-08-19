//
//  EventModel+Ext.swift
//  42Events
//
//  Created by Duy Nguyen on 19/07/2021.
//

import FTDomain

extension EventModel {
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

extension EventType {
    public var displayName: String {
        switch self {
        case .multiple:
            return Text.multipleSubmission
        case .single:
            return Text.singleSubmission
        }
    }
}

extension SportType {
    public var iconName: String {
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
