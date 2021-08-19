//
//  SettingCellVM.swift
//  42Events
//
//  Created by Duy Nguyen on 21/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SettingCellVM {
    private let _setting = BehaviorRelay<Setting>(value: Setting())
    var setting: Driver<Setting> {
        return self._setting
            .asObservable()
            .asDriverOnErrorJustComplete()
    }
    
    var item: Setting {
        return self._setting.value
    }
    
    init(_ setting: Setting) {
        self._setting.accept(setting)
    }
}
