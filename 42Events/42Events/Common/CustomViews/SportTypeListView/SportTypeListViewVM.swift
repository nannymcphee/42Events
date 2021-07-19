//
//  SportTypeListViewVM.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import RxSwift
import RxCocoa
import XCoordinator
import FTDomain

class SportTypeListViewVM: BaseVM, ViewModelType, EventPublisherType {
    // MARK: Initialization
    override init() {}
    
    // MARK: Inputs
    struct Input {
        let itemSelected: Observable<ActivityCellItem>
    }
    
    // MARK: Outputs
    struct Output {
        let activities: Driver<[ActivitySection]>
    }
    
    // MARK: Event
    enum Event {
        case didSelectSportType(String)
    }
    
    // MARK: Public variables
    public var eventPublisher = PublishSubject<Event>()
    
    
    // MARK: Private variables
    private var activities = BehaviorRelay<[Activity]>(value: [
        Activity(name: "Running", color: AppColors.teal,   image: #imageLiteral(resourceName: "ic_running")),
        Activity(name: "Cycling", color: AppColors.blue,   image: #imageLiteral(resourceName: "ic_cycling")),
        Activity(name: "Walking", color: AppColors.orange, image: #imageLiteral(resourceName: "ic_walking")),
    ])
    private let _sections = BehaviorRelay<[ActivitySection]>(value: [])
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        let sections = [ActivitySection.activity(title: "", items: [])]
        let initState = SectionedTableViewState<ActivitySection>(sections: sections)
        let command = PublishSubject<TableViewEditingCommand<ActivityCellItem>>()
        
        command.scan(initState) { (state, action) in
            return state.execute(command: action)
        }
        .startWith(initState)
        .map { $0.sections }
        .bind(to: self._sections)
        .disposed(by: self.disposeBag)
        
        activities.asObservable()
            .map { $0.map { EventActivityCellVM($0) } }
            .map { $0.map { ActivityCellItem.activity(viewModel: $0) } }
            .map { TableViewEditingCommand.reloadItems(items: $0, section: 0) }
            .bind(to: command)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .do(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                case .activity(let viewModel, _):
                    self.eventPublisher.onNext(.didSelectSportType(viewModel.item.name.lowercased()))
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(activities: _sections.asDriver())
    }
    
    // MARK: Privates functions
}
