//
//  EventCellVM.swift
//  42Events
//
//  Created by Duy Nguyen on 14/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class EventCellVM {
    private let _event = BehaviorRelay<EventModel>(value: EventModel())
    var event: Driver<EventModel> {
        return self._event
            .asObservable()
            .asDriverOnErrorJustComplete()
    }
    
    var item: EventModel {
        return self._event.value
    }
    
    init(_ event: EventModel) {
        self._event.accept(event)
    }
}
