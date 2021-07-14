//
//  EventActivityCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class EventActivityCollectionViewCell: CollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lbActivityName: UILabel!
    @IBOutlet weak var ivThumbnail: UIImageView!
    
    // MARK: - Variables
    private var binding: Binder<Activity> {
        return Binder(self) { (cell, activity) in
            cell.configureCell(data: activity)
        }
    }
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        vContainer.customBorder(cornerRadius: 12, borderWidth: 1, color: .clear)
    }
    
    override func reset() {
        super.reset()
        vContainer.backgroundColor = .clear
        lbActivityName.text = nil
        ivThumbnail.image = nil
    }

    // MARK: - Public functions
    public func configureCell(data: Activity) {
        vContainer.backgroundColor = data.color
        lbActivityName.text = data.name.localized
        ivThumbnail.image = data.image
    }
    
    public func bind(_ viewModel: EventActivityCellVM) {
        viewModel.activity
            .drive(self.binding)
            .disposed(by: disposeBag)
    }
}

