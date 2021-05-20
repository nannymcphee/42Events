//
//  SportTypeTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

protocol SportTypeTableViewCellDelegate: class {
    func didSelectSportType(_ type: String)
}

class SportTypeTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var cvSportType: UICollectionView!
    
    // MARK: - Variables
    weak var delegate: SportTypeTableViewCellDelegate?
    
    private var activities: [Activity] = [
        Activity(name: "Running", color: AppColors.teal, image: #imageLiteral(resourceName: "ic_running")),
        Activity(name: "Cycling", color: AppColors.blue, image: #imageLiteral(resourceName: "ic_cycling")),
        Activity(name: "Walking", color: AppColors.orange, image: #imageLiteral(resourceName: "ic_walking")),
    ]
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureCollectionView()
    }
    
    // MARK: - Private functions
    private func configureCollectionView() {
        cvSportType.registerNib(EventActivityCollectionViewCell.self)
        cvSportType.delegate = self
        cvSportType.dataSource = self
        cvSportType.reloadData()
    }
}

// MARK: - Extensions
extension SportTypeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activityCell: EventActivityCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let activity = activities[indexPath.item]
        activityCell.configureCell(data: activity)
        return activityCell
    }
}

extension SportTypeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let activity = activities[indexPath.item]
        self.delegate?.didSelectSportType(activity.name.lowercased())
    }
}

extension SportTypeTableViewCell: UICollectionViewDelegateFlowLayout {
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
