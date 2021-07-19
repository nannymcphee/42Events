//
//  TagCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import FTDomain

class TagCollectionViewCell: CollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var ivTag: UIImageView!
    @IBOutlet weak var lbTitle: PaddingLabel!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vIconContainer: UIView!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    override func reset() {
        super.reset()
        self.vIconContainer.isHidden = true
        self.lbTitle.text = nil
    }
    
    // MARK: - Private functions
    private func configureUI() {
        self.lbTitle.font = fontScheme.medium12
        self.lbTitle.textColor = AppColors.black
        self.lbTitle.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        self.vContent.customBorder(cornerRadius: 15, borderWidth: 1.0, color: AppColors.black)
    }
    
    // MARK: - Public functions
    public func configureCell(data: EventTag) {
        if let iconName = data.iconName {
            self.vIconContainer.isHidden = false
            self.ivTag.image = UIImage(named: iconName)
        }
        self.lbTitle.text = data.title.localized
    }
}
