//
//  NibLoadable.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit

public protocol NibLoadable: class {
    static var nibName: String { get }
    static var nibBundle: Bundle? { get }
}

public extension NibLoadable {
    static var nib: UINib {
        UINib(nibName: nibName, bundle: nibBundle)
    }
    
    static var nibName: String {
        String(describing: self)
    }
    
    static var nibBundle: Bundle? {
        Bundle(for: self)
    }
}

public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
