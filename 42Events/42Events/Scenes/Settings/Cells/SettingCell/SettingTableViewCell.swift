//
//  SettingTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import Localize_Swift
import FTDomain

class SettingTableViewCell: TableViewCell {

    @IBOutlet var vSeparators: [UIView]!
    @IBOutlet weak var ivType: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var ivArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func reset() {
        super.reset()
        self.vSeparators.forEach { $0.isHidden = true }
        self.lbLanguage.isHidden = true
        self.ivType.image = nil
        self.lbTitle.text = nil
    }
    
    public func configureCell(data: Setting) {
        self.ivType.image = data.image
        self.lbTitle.text = data.name.localized
        
        if data.id == ActionSettingType.language.id {
            self.vSeparators.forEach { $0.isHidden = false }
            self.lbLanguage.isHidden = false
            self.lbLanguage.text = AppConstants.languages.first(where: { $0.code == Localize.currentLanguage() })?.name
        }
    }
    
    
}
