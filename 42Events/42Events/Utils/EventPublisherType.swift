//
//  EventPublisherType.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift

public protocol EventPublisherType {
    associatedtype Event
    var eventPublisher: PublishSubject<Event> { get }
}
