//
//  EventTag.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit

public struct EventTag {
    public var title: String
    public var iconName: String?
    
    public init(title: String, iconName: String? = nil) {
        self.title = title
        self.iconName = iconName
    }
}
