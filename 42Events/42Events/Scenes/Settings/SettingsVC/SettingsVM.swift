//
//  SettingsVM.swift
//  42Events
//
//  Created by Duy Nguyen on 20/07/2021.
//

import RxSwift
import RxCocoa
import Resolver
import FTDomain

class SettingsVM: BaseVM, ViewModelType, EventPublisherType {
    
    // MARK: Inputs
    struct Input {
        let itemSelected: Observable<(setting: SettingCellItem, indexPath: IndexPath)>
        let releaseTrigger: Observable<Void>
    }
    
    // MARK: Outputs
    struct Output {
        let settingsSection: Driver<[SettingSection]>
        let showDropdown: Driver<IndexPath>
    }
    
    // MARK: Event
    enum Event {
        case releaseIfNeeded
    }
    
    
    // MARK: Public variables
    public var eventPublisher = PublishSubject<Event>()
    
    
    // MARK: Private variables
    private var settingsRelay = BehaviorRelay<[Setting]>(value: [
        Setting(actionType: .login,     image: UIImage(named: "ic_login")),
        Setting(actionType: .signUp,    image: UIImage(named: "ic_sign_up")),
        Setting(actionType: .faq,       image: UIImage(named: "ic_faq")),
        Setting(actionType: .contactUs, image: UIImage(named: "ic_contact")),
        Setting(actionType: .language,  image: UIImage(named: "ic_language")),
    ])
    private var selectedLanguageRelay = BehaviorRelay<Int>(value: 0)
    private let sectionsRelay = BehaviorRelay<[SettingSection]>(value: [])
    private var showDropdownSubject = PublishSubject<IndexPath>()
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        let sections = [SettingSection.settings(title: "", items: [])]
        let initState = SectionedTableViewState<SettingSection>(sections: sections)
        let command = PublishSubject<TableViewEditingCommand<SettingCellItem>>()
        
        // Settings section
        command.scan(initState) { (state, action) in
            return state.execute(command: action)
        }
        .startWith(initState)
        .map { $0.sections }
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
        
        settingsRelay
            .map { $0.map { SettingCellVM($0) } }
            .map { $0.map { SettingCellItem.setting(viewModel: $0) } }
            .map { TableViewEditingCommand.reloadItems(items: $0, section: 0) }
            .bind(to: command)
            .disposed(by: disposeBag)
        
        // Item selected
        input.itemSelected
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item.setting {
                case .setting(let viewModel, _):
                    self.handleSelectSetting(viewModel.item, at: item.indexPath)
                }
            })
            .disposed(by: disposeBag)
        
        // Release trigger
        input.releaseTrigger
            .map { Event.releaseIfNeeded }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        return Output(settingsSection: sectionsRelay.asDriver(),
                      showDropdown: showDropdownSubject.asDriverOnErrorJustComplete())
    }
    
    // MARK: Privates functions
    private func handleSelectSetting(_ setting: Setting, at indexPath: IndexPath) {
        if setting.id == ActionSettingType.language.id {
            showDropdownSubject.onNext(indexPath)
        }
    }
}
