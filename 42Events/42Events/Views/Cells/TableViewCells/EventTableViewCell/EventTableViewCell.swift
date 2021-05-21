//
//  EventTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit

class EventTableViewCell: TableViewCell {

    @IBOutlet weak var vEventContent: EventContentView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func reset() {
        super.reset()
        self.vEventContent.resetData()
        self.vEventContent.updateLocalize()
    }
    
    public func configureCell(data: Event) {
        self.vEventContent.populateData(data)
    }
}
