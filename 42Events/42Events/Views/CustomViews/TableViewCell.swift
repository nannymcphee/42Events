//
//  TableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit

open class TableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.reset()
    }
    
    // MARK: - API
    
    open func initialize() {
        
    }
    
    open func reset() {
        
    }
}
