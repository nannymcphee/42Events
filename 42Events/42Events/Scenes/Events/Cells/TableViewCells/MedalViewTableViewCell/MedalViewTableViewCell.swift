//
//  MedalViewTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import FTDomain

class MedalViewTableViewCell: TableViewCell {
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var tvTags: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
    override func reset() {
        super.reset()
        self.ivThumbnail.image = nil
        self.lbTitle.text = nil
        self.lbSubtitle.text = nil
        self.tvTags.text = nil
    }
    
    private func initUI() {
        self.ivThumbnail.customBorder(cornerRadius: 12, borderWidth: 1, color: .clear)
        self.tvTags.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    }
    
    private func getTagsText(data: EventModel) -> String? {
        var firstLineComponents: [String] = [data.sportType.rawValue.capitalizeFirst.localized]
        var firstLine = ""
        var secondLine = ""
        
        if data.raceRunners >= 1 {
            firstLineComponents.append("\(String(data.raceRunners)) \(Text.joined.localized)")
        }
        
        if let price = data.racePrice {
            firstLineComponents.append(price.localized)
        }
        
        if let categories = data.categories {
            secondLine = "\n" + categories.joined(separator: ", ")
        }
        
        firstLine = firstLineComponents.joined(separator: "・")
        let thirdLine = data.eventType.displayName.localized
        let text: String = "\(firstLine)\(secondLine)\n\(thirdLine)"
        return text
    }
    
    public func configureCell(data: EventModel) {
        self.ivThumbnail.setImage(url: data.medalViewImage)
        self.lbTitle.text = data.raceName
        self.lbSubtitle.text = data.racePeriod
        self.tvTags.text = self.getTagsText(data: data)
        self.layoutIfNeeded()
    }
}
