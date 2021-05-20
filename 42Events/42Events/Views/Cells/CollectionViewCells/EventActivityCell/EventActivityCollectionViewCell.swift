//
//  EventActivityCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

class EventActivityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lbActivityName: UILabel!
    @IBOutlet weak var ivThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vContainer.customBorder(cornerRadius: 12, borderWidth: 1, color: .clear)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vContainer.backgroundColor = .clear
        lbActivityName.text = nil
        ivThumbnail.image = nil
    }

    public func configureCell(data: Activity) {
        vContainer.backgroundColor = data.color
        lbActivityName.text = data.name
        ivThumbnail.image = data.image
    }
}
