//
//  NAAnimatableSectionModelType.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import UIKit
import RxDataSources

public protocol NAIdentifiableType: IdentifiableType {
    var objectId: String { get }
}

public protocol NAAnimatableSectionModelType: AnimatableSectionModelType where Item: NAIdentifiableType {
    
}

extension Array where Element: NAIdentifiableType {
    func first(byId id: String) -> Element? {
        return self.first { $0.objectId == id }
    }
    
    func firstIndex(byId id: String) -> Int? {
        return self.firstIndex { $0.objectId == id }
    }
}

extension Array where Element: NAAnimatableSectionModelType  {
    func indexPath(byId id: String) -> IndexPath? {
        for section in self.enumerated() {
            if let firstIndex = section.element.items.firstIndex(byId: id) {
                return IndexPath(row: firstIndex, section: section.offset)
            }
        }
        return nil
    }
    
    func hasItems() -> Bool {
        for section in self {
            if section.items.count > 0 {
                return true
            }
        }
        return false
    }
}
