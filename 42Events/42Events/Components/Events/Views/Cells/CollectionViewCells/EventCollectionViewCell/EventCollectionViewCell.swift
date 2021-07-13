//
//  EventCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit

class EventCollectionViewCell: DynamicHeightCollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var vEventContent: EventContentView!
    
    // MARK: - Variables
    
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vEventContent.resetData()
        self.vEventContent.updateLocalize()
    }
    
    // MARK: - Private functions
    

    // MARK: - Public functions
    public func configureCell(data: EventModel) {
        self.vEventContent.populateData(data)
    }
}

// MARK: - Extensions
