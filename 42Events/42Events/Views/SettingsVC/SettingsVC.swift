//
//  SettingsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import DropDown
import Localize_Swift

class SettingsVC: BaseViewController {
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
    private let languageDropDown = DropDown()
    private var settings = [
        Setting(actionType: .login,     image: UIImage(named: "ic_login")),
        Setting(actionType: .signUp,    image: UIImage(named: "ic_sign_up")),
        Setting(actionType: .faq,       image: UIImage(named: "ic_faq")),
        Setting(actionType: .contactUs, image: UIImage(named: "ic_contact")),
        Setting(actionType: .language,  image: UIImage(named: "ic_language")),
    ]
    private var selectedLanguageIndex = 0
    
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        self.initTableView()
        self.initDropDown()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.tbSettings.reloadData()
    }
    
    // MARK: - ACTIONS
    
    
    // MARK: - FUNCTIONS
    private func initNavigationBar() {
        self.showBackButton()
    }
    
    private func initTableView() {
        tbSettings.registerNib(SettingTableViewCell.self)
        tbSettings.delegate = self
        tbSettings.dataSource = self
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
}

// MARK: - EXTENSIONS
extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(data: self.settings[indexPath.row])
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if self.settings[indexPath.row].id == ActionSettingType.language.id {
            let cell = tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            cell.ivArrow.animationRotate90Degrees()
            self.languageDropDown.bottomOffset = CGPoint(x: 0, y: cell.lbLanguage.frame.height + 10)
            self.languageDropDown.anchorView = cell.lbLanguage
            self.languageDropDown.cancelAction = {
                cell.ivArrow.animationRotateBackToDefault()
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
}
