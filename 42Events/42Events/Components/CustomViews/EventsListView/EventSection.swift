//
//  EventSection.swift
//  42Events
//
//  Created by Duy Nguyen on 14/07/2021.
//

import RxDataSources
import UIKit

enum EventSection {
    case events(title: String, items: [EventCellItem])
}

enum EventCellItem {
    case event(viewModel: EventCellVM, _ uuid: String = UUID().uuidString)
}

extension EventSection: NAAnimatableSectionModelType {
    
    typealias Item = EventCellItem
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .events(let title, _):
            return title
        }
    }
    
    var items: [EventCellItem] {
        switch self {
        case .events(_, let items):
            return items
        }
    }
    
    init(original: EventSection, items: [EventCellItem]) {
        switch original {
        case .events(let title, _):
            self = .events(title: title, items: items)
        }
    }
}

extension EventCellItem: NAIdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: EventCellItem.Identity {
        switch self {
        case .event(_, let uuid):
            return uuid
        }
    }
    
    var objectId: String {
        switch self {
        case .event(_, let uuid):
            return uuid
        }
    }
    
    static func ==(lhs: EventCellItem, rhs: EventCellItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
