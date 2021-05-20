//
//  FeaturedTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import ImageSlideshow

class FeaturedTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var vSlideshow: ImageSlideshow!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSlideshow()
    }
    
    // MARK: - Private functions
    private func configureSlideshow() {
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = AppColors.red
        pageIndicator.pageIndicatorTintColor = AppColors.lightGray
        vSlideshow.pageIndicator = pageIndicator
        vSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        vSlideshow.slideshowInterval = 5.0
        vSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
    }
    
    // MARK: - Public functions
    public func configureCell(data: [Event]) {
        let imageSource = data.compactMap { KingfisherSource(urlString: $0.bannerCard) }
        vSlideshow.setImageInputs(imageSource)
    }
}
