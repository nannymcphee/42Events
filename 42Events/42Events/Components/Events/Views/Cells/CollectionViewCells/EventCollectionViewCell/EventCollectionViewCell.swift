//
//  EventCollectionViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import FTDomain

class EventCollectionViewCell: DynamicHeightCollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var vEventContent: EventContentView!
    
    // MARK: - Variables
    private var binding: Binder<EventModel> {
        return Binder(self) { (cell, event) in
            cell.configureCell(data: event)
        }
    }
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func reset() {
        super.reset()
        self.vEventContent.resetData()
        self.vEventContent.updateLocalize()
    }
    
    // MARK: - Private functions
    private func configureCell(data: EventModel) {
        self.vEventContent.populateData(data)
    }

    // MARK: - Public functions
    public func bind(_ viewModel: EventCellVM) {
        viewModel.event
            .drive(self.binding)
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
