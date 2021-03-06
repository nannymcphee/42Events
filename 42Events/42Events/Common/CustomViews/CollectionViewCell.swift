//
//  CollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import RxSwift

open class CollectionViewCell: UICollectionViewCell {
    
    public var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        disposeBag = DisposeBag()
    }
}
