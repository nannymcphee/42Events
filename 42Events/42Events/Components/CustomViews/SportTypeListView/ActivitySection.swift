//
//  ActivitySection.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxDataSources
import UIKit

enum ActivitySection {
    case activity(title: String, items: [ActivityCellItem])
}

enum ActivityCellItem {
    case activity(viewModel: EventActivityCellVM, _ uuid: String = UUID().uuidString)
}

extension ActivitySection: NAAnimatableSectionModelType {
    
    typealias Item = ActivityCellItem
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .activity(let title, _):
            return title
        }
    }
    
    var items: [ActivityCellItem] {
        switch self {
        case .activity(_, let items):
            return items
        }
    }
    
    init(original: ActivitySection, items: [ActivityCellItem]) {
        switch original {
        case .activity(let title, _):
            self = .activity(title: title, items: items)
        }
    }
}

extension ActivityCellItem: NAIdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: ActivityCellItem.Identity {
        switch self {
        case .activity(_, let uuid):
            return uuid
        }
    }
    
    var objectId: String {
        switch self {
        case .activity(_, let uuid):
            return uuid
        }
    }
    
    static func ==(lhs: ActivityCellItem, rhs: ActivityCellItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
