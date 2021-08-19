//
//  EventListViewVM.swift
//  42Events
//
//  Created by Duy Nguyen on 14/07/2021.
//

import RxSwift
import RxCocoa
import XCoordinator
import FTDomain

class EventListViewVM: BaseVM, ViewModelType {
    // MARK: Initialization
    init(events: [EventModel]) {
        self.eventModels = events
    }
    
    // MARK: Inputs
    struct Input {
        
    }
    
    // MARK: Outputs
    struct Output {
        let eventModels: Driver<[EventSection]>
    }
    
    // MARK: Private variables
    private var eventModels: [EventModel] {
        didSet {
            eventModelsRelay.accept(eventModels)
        }
    }
    private let eventModelsRelay = BehaviorRelay<[EventModel]>(value: [])
    private let _sections = BehaviorRelay<[EventSection]>(value: [])
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        let sections = [EventSection.events(title: "", items: [])]
        let initState = SectionedTableViewState<EventSection>(sections: sections)
        let command = PublishSubject<TableViewEditingCommand<EventCellItem>>()
        
        command.scan(initState) { (state, action) in
            return state.execute(command: action)
        }
        .startWith(initState)
        .map { $0.sections }
        .bind(to: self._sections)
        .disposed(by: self.disposeBag)
        
        eventModelsRelay
            .map { $0.map { EventCellVM($0) } }
            .map { $0.map { EventCellItem.event(viewModel: $0) } }
            .map { TableViewEditingCommand.reloadItems(items: $0, section: 0) }
            .bind(to: command)
            .disposed(by: disposeBag)
        
        return Output(eventModels: _sections.asDriver())
    }
    
    public func updateEvents(_ events: [EventModel]) {
        self.eventModels = events
    }
}
