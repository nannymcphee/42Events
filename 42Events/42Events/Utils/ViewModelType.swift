//
//  ViewModelType.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
