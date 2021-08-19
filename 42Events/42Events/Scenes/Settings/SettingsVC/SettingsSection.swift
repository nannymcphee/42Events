//
//  SettingsSection.swift
//  42Events
//
//  Created by Duy Nguyen on 21/07/2021.
//

import RxDataSources
import UIKit

enum SettingSection {
    case settings(title: String, items: [SettingCellItem])
}

enum SettingCellItem {
    case setting(viewModel: SettingCellVM, _ uuid: String = UUID().uuidString)
}

extension SettingSection: NAAnimatableSectionModelType {
    
    typealias Item = SettingCellItem
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .settings(let title, _):
            return title
        }
    }
    
    var items: [SettingCellItem] {
        switch self {
        case .settings(_, let items):
            return items
        }
    }
    
    init(original: SettingSection, items: [SettingCellItem]) {
        switch original {
        case .settings(let title, _):
            self = .settings(title: title, items: items)
        }
    }
}

extension SettingCellItem: NAIdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: SettingCellItem.Identity {
        switch self {
        case .setting(_, let uuid):
            return uuid
        }
    }
    
    var objectId: String {
        switch self {
        case .setting(_, let uuid):
            return uuid
        }
    }
    
    static func ==(lhs: SettingCellItem, rhs: SettingCellItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
