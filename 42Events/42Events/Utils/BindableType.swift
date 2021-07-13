//
//  BindableType.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import UIKit

public protocol BindableType: AnyObject {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

public extension BindableType where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

public extension BindableType where Self: UITableViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

public extension BindableType where Self: UICollectionViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

public extension BindableType where Self: UIApplicationDelegate {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}
