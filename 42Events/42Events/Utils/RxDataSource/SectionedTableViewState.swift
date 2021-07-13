//
//  SectionedTableViewState.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import UIKit

public enum TableViewEditingCommand<T> {
    case appendItem(item: T, section: Int)
    case appendItems(items: [T], section: Int)
    case moveItem(sourceIndex: IndexPath, destinationIndex: IndexPath)
    case updateItem(T)
    case deleteItem(T)
    case reloadItems(items: [T], section: Int)
}

public struct SectionedTableViewState<T: NAAnimatableSectionModelType> {
    public typealias R = T.Item
    fileprivate var _sections: [T]
    
    public var sections: [T] {
        return self._sections
    }
    
    public init(sections: [T]) {
        self._sections = sections
    }
    
    public func execute(command: TableViewEditingCommand<R>) -> SectionedTableViewState<T> {
        switch command {
        case .appendItem(let item, let section):
            var sections = self._sections
            let items = sections[section].items + [item]
            sections[section] = T(original: _sections[section], items: items)
            return SectionedTableViewState(sections: sections)
        case .appendItems(let items, let section):
            var sections = self._sections
            let items = self._sections[section].items + items
            sections[section] = T(original: _sections[section], items: items)
            return SectionedTableViewState(sections: sections)
        case .updateItem(let item):
            if let indexPath = self._sections.indexPath(byId: item.objectId) {
                var sections = self._sections
                var section = self._sections[indexPath.section]
                var items = section.items
                items[indexPath.row] = item
                section = T(original: section, items: items)
                sections[indexPath.section] = section
                return SectionedTableViewState(sections: sections)
            }
            return SectionedTableViewState(sections: self._sections)
        case .deleteItem(let item):
            var sections = self._sections
            if let indexPath = sections.indexPath(byId: item.objectId) {
                var section = sections[indexPath.section]
                var items = section.items
                items.remove(at: indexPath.row)
                section = T(original: section, items: items)
                sections[indexPath.section] = section
            }
            return SectionedTableViewState(sections: sections)
        case .moveItem(let sourceIndex, let destinationIndex):
            var sections = self._sections
            var sourceItems = sections[sourceIndex.section].items
            var destinationItems = sections[destinationIndex.section].items
            
            if sourceIndex.section == destinationIndex.section {
                destinationItems.insert(destinationItems.remove(at: sourceIndex.row),
                                        at: destinationIndex.row)
                let destinationSection = T(original: sections[destinationIndex.section], items: destinationItems)
                sections[sourceIndex.section] = destinationSection
                
                return SectionedTableViewState(sections: sections)
            } else {
                let item = sourceItems.remove(at: sourceIndex.row)
                destinationItems.insert(item, at: destinationIndex.row)
                let sourceSection = T(original: sections[sourceIndex.section], items: sourceItems)
                let destinationSection = T(original: sections[destinationIndex.section], items: destinationItems)
                sections[sourceIndex.section] = sourceSection
                sections[destinationIndex.section] = destinationSection
                
                return SectionedTableViewState(sections: sections)
            }
        case .reloadItems(let items, let index):
            var sections = self._sections
            var section = sections[index]
            section = T(original: section, items: items)
            sections[index] = section
            return SectionedTableViewState(sections: sections)
        }
    }
}
