//
//  SettingsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import DropDown
import Localize_Swift
import RxSwift
import RxCocoa
import FTDomain
import RxDataSources

class SettingsVC: BaseViewController, BindableType {
    enum ViewType {
        case events
        case medals
    }
    
    // MARK: - Instance
    public static func instance() -> SettingsVC {
        let vc = SettingsVC()
        return vc
    }
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var tbSettings: UITableView!
        
    // MARK: - VARIABLES
    internal var viewModel: SettingsVM!
    private var selectedLanguageIndex: Int = 0
    private let languageDropDown = DropDown()
    private let releaseTrigger = PublishSubject<Void>()
    private let settingSelectTrigger = PublishSubject<(setting: SettingCellItem, indexPath: IndexPath)>()
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<SettingSection>(
        configureCell: { (dataSource, tableView, indexPath, item) -> SettingTableViewCell in
            let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            switch item {
            case .setting(let viewModel, _):
                cell.bind(viewModel)
            }
            return cell
        })
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        self.initTableView()
        self.initDropDown()
        self.bindingUI()
    }
    
    deinit {
        releaseTrigger.onNext(())
        releaseTrigger.onCompleted()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.tbSettings.reloadData()
    }
    
    // MARK: - FUNCTIONS
    func bindViewModel() {
        let input = SettingsVM.Input(itemSelected: settingSelectTrigger,
                                     releaseTrigger: releaseTrigger)
        let output = viewModel.transform(input: input)
        
        // Settings dataSource
        output.settingsSection
            .drive(tbSettings.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // Dropdown show trigger
        output.showDropdown
            .drive(with: self, onNext: { $0.showDropDown(at: $1) })
            .disposed(by: disposeBag)
    }
    
    private func bindingUI() {
        // Item select trigger
        Observable.zip(tbSettings.rx.modelSelected(SettingCellItem.self), tbSettings.rx.itemSelected)
            .map { ($0.0, $0.1) }
            .do(onNext: { [weak self] tuple in
                self?.tbSettings.deselectRow(at: tuple.1, animated: false)
            })
            .bind(to: settingSelectTrigger)
            .disposed(by: disposeBag)
    }
    
    private func initNavigationBar() {
        self.showBackButton()
    }
    
    private func initTableView() {
        tbSettings.registerNib(SettingTableViewCell.self)
        tbSettings.rowHeight = 60
    }
    
    private func initDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 40
        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = AppColors.red.withAlphaComponent(0.1)
        appearance.cornerRadius = 5
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 5
        appearance.animationduration = 0.25
        appearance.textColor = AppColors.black
        appearance.textFont = fontScheme.medium14
        
        self.selectedLanguageIndex = AppConstants.languages.firstIndex(where: { $0.code == Localize.currentLanguage() }) ?? 0
        self.languageDropDown.dataSource = AppConstants.languages.map { $0.name }
        self.languageDropDown.selectRow(self.selectedLanguageIndex)
    }
    
    private func showDropDown(at indexPath: IndexPath) {
        guard let cell = tbSettings.cellForRow(at: indexPath) as? SettingTableViewCell else { return }
        cell.ivArrow.animationRotate90Degrees()
        self.languageDropDown.bottomOffset = CGPoint(x: 0, y: cell.lbLanguage.frame.height + 10)
        self.languageDropDown.anchorView = cell.lbLanguage
        self.languageDropDown.cancelAction = { [weak cell] in
            cell?.ivArrow.animationRotateBackToDefault()
        }
        self.languageDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            Localize.setCurrentLanguage(AppConstants.languages[index].code)
            self.selectedLanguageIndex = index
            cell.lbLanguage.text = item
        }
        self.languageDropDown.show()
    }
}
