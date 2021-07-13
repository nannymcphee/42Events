//
//  Activity.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

struct Activity {
    var name: String
    var color: UIColor
    var image: UIImage
    
    init() {
        self.name = ""
        self.color = .clear
        self.image = UIImage()
    }
    
    init(name: String, color: UIColor, image: UIImage) {
        self.name = name
        self.color = color
        self.image = image
    }
}
