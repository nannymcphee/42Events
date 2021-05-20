//
//  FeaturedTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import ImageSlideshow

class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var vSlideshow: ImageSlideshow!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSlideshow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureSlideshow() {
        vSlideshow.slideshowInterval = 5.0
        vSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        vSlideshow.pageIndicator = nil
    }
    
    public func configureCell(data: [Event]) {
        let imageSource = data.compactMap { KingfisherSource(urlString: $0.bannerCard) }
        vSlideshow.setImageInputs(imageSource)
    }
}
