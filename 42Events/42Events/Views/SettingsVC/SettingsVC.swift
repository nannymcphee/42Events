//
//  SettingsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import DropDown

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
        Setting(actionType: .login, image: UIImage(named: "ic_login")),
        Setting(actionType: .signUp, image: UIImage(named: "ic_sign_up")),
        Setting(actionType: .faq, image: UIImage(named: "ic_faq")),
        Setting(actionType: .contactUs, image: UIImage(named: "ic_contact")),
        Setting(actionType: .language, image: UIImage(named: "ic_language")),
    ]
    
    private var languages = [
        Language(code: "en", name: "English"),
        Language(code: "zh-Hans", name: "简体 中文"),
        Language(code: "zh-Hant", name: "繁體 中文"),
        Language(code: "id", name: "Bahasa Indonesia"),
        Language(code: "th", name: "ภาษา ไทย"),
        Language(code: "vi", name: "Tiếng Việt"),
    ]
    private var selectedLanguageIndex = 0
    
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        self.initTableView()
        self.initDropDown()
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
        
        self.languageDropDown.dataSource = self.languages.map { $0.name }
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
                self.selectedLanguageIndex = index
                cell.lbLanguage.text = item
            }
            self.languageDropDown.show()
        }
    }
}
