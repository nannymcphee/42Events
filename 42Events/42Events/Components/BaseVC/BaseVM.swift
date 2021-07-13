//
//  BaseVM.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift
import RxCocoa

open class BaseVM: NSObject {
    public let disposeBag = DisposeBag()
    
    override public init() {
        super.init()
        
        print("---------> 🍏 🍏 🍏 inited \(type(of: self))")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("---------> 🍎 🍎 🍎 deinited \(type(of: self))")
    }
}
