//
//  SportTypeRxCollectionView.swift
//  42Events
//
//  Created by Duy Nguyen on 28/05/2021.
//

import UIKit
import RxSwift
import RxDataSources

class SportTypeRxCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    
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
        self.registerNib(EventActivityCollectionViewCell.self)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<ActivitySection> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ActivitySection>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            switch item {
            case .activity(let viewModel, _):
                let cell: EventActivityCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel)
                return cell
            }
        })
        return dataSource
    }
}

extension SportTypeRxCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let width = (screenSize.width / 3) - 20
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
