//
//  BaseView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import RxSwift

class BaseView: UIView, NibLoadable {
    @IBOutlet weak var subView: UIView!
    
    public let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
        self.updateLocalize()
    }
    
    public func updateLocalize() {}
    
    public func initialize() {}
    
    public func nibSetup() {
        subView                    = loadViewFromNib()
        subView.frame              = bounds
        subView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        subView.translatesAutoresizingMaskIntoConstraints = true
        subView.backgroundColor    = .clear
        backgroundColor            = .clear
        addSubview(subView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle  = Bundle(for: type(of: self))
        let nib     = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
