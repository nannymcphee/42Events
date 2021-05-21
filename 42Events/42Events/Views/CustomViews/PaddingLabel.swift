//
//  PaddingLabel.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        textContainerSize = CGSize(width: insetRect.width, height: insetRect.height)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.horizontal,
                      height: size.height + textInsets.vertical)
    }
    
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - textInsets.horizontal
        }
    }
    
    private var textContainerSize: CGSize = .zero
}

//MARK: - Public functions
extension PaddingLabel {
    public func resetData() {
        self.attributedText = nil
        self.text = nil
    }
}
