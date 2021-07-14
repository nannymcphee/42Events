//
//  EventsRxCollectionView.swift
//  42Events
//
//  Created by Duy Nguyen on 14/07/2021.
//

import UIKit
import RxSwift
import RxDataSources
import MSPeekCollectionViewDelegateImplementation

class EventsRxCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    private var behavior: MSCollectionViewPeekingBehavior!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.rx.setDelegate(self) .disposed(by: self.disposeBag)
        self.registerNib(EventCollectionViewCell.self)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.behavior = MSCollectionViewPeekingBehavior(cellSpacing: 10,
                                                        cellPeekWidth: 20,
                                                        maximumItemsToScroll: 1,
                                                        numberOfItemsToShow: 1,
                                                        scrollDirection: .horizontal)
        self.configureForPeekingBehavior(behavior: behavior)
    }
    
    func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<EventSection> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<EventSection>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            switch item {
            case .event(let viewModel, _):
                let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel)
                return cell
            }
        })
        return dataSource
    }
}

extension EventsRxCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
