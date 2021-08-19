//
//  EventActivityCellVM.swift
//  42Events
//
//  Created by Duy Nguyen on 14/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import FTDomain

class EventActivityCellVM {
    private let _activity = BehaviorRelay<Activity>(value: Activity())
    var activity: Driver<Activity> {
        return self._activity
            .asObservable()
            .asDriverOnErrorJustComplete()
    }
    
    var item: Activity {
        return self._activity.value
    }
    
    init(_ activity: Activity) {
        self._activity.accept(activity)
    }
}
