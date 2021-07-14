//
//  SportTypeListView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SportTypeListView: BaseView {
    @IBOutlet weak var lbEventsSection: UILabel!
    @IBOutlet weak var cvSportType: SportTypeRxCollectionView!
    
    // MARK: - Variables
    private var viewModel: SportTypeListViewVM!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func updateLocalize() {
        super.updateLocalize()
        self.lbEventsSection.text = Text.events.localized
        self.cvSportType.reloadData()
    }
    
    // MARK: - Public functions
    static func instance(viewModel: SportTypeListViewVM) -> SportTypeListView {
        let nib = UINib(nibName: "SportTypeListView", bundle: Bundle(for: SportTypeListView.self))
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? SportTypeListView else {
            return SportTypeListView()
        }
        view.viewModel = viewModel
        view.bindViewModel()
        return view
    }
    
    // MARK: - Private functions
    private func bindViewModel() {
        let itemSelected = self.cvSportType.rx.modelSelected(ActivityCellItem.self).asObservable()
        let input = SportTypeListViewVM.Input(itemSelected: itemSelected)
        let output = viewModel.transform(input: input)
        
        let dataSource = self.cvSportType.dataSource()
        output.activities
            .drive(cvSportType.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
