//
//  BaseView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit

class BaseView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateLocalize()
    }
    public func updateLocalize() {}
}
