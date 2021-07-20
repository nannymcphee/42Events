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
        let itemSelected: Observable<(setting: Setting, indexPath: IndexPath)>
        let releaseTrigger: Observable<Void>
    }
    
    // MARK: Outputs
    struct Output {
        let settings: Driver<[Setting]>
        let showDropdown: Driver<IndexPath?>
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
    private var showDropdownRelay = BehaviorRelay<IndexPath?>(value: nil)
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        // Item selected
        input.itemSelected
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.handleSelectSetting(item.setting, at: item.indexPath)
            })
            .disposed(by: disposeBag)
        
        // Release trigger
        input.releaseTrigger
            .map { Event.releaseIfNeeded }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        return Output(settings: settingsRelay.asDriverOnErrorJustComplete(),
                      showDropdown: showDropdownRelay.asDriverOnErrorJustComplete())
    }
    
    // MARK: Privates functions
    private func handleSelectSetting(_ setting: Setting, at indexPath: IndexPath) {
        if setting.id == ActionSettingType.language.id {
            showDropdownRelay.accept(indexPath)
        }
    }
}
