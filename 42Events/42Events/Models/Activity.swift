//
//  Activity.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

public struct Activity {
    public var name: String
    public var color: UIColor
    public var image: UIImage
    
    public init() {
        self.name = ""
        self.color = .clear
        self.image = UIImage()
    }
    
    public init(name: String, color: UIColor, image: UIImage) {
        self.name = name
        self.color = color
        self.image = image
    }
}
