//
//  SwipeBackNavigationController.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import SwipeBack
import UIKit

open class SwipeBackNavigationController: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        swipeBackEnabled = true
    }
}
