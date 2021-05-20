//
//  EventListTableViewCell.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation

class EventListTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvEvents: UICollectionView!
    
    // MARK: - Variables
    private var eventList: [Event] = []
    private var behavior: MSCollectionViewPeekingBehavior!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCollectionView()
    }
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbTitle.text = nil
        self.eventList.removeAll()
        self.cvEvents.reloadData()
    }
    
    // MARK: - Private functions
    private func initCollectionView() {
        self.cvEvents.registerNib(EventCollectionViewCell.self)
        self.cvEvents.delegate = self
        self.cvEvents.dataSource = self
    }
    
    // MARK: - Public functions
    public func configureCell(title: String?, data: [Event]) {
        self.lbTitle.text = title
        self.eventList = data
        self.behavior = MSCollectionViewPeekingBehavior(cellSpacing: 10,
                                                        cellPeekWidth: 20,
                                                        maximumItemsToScroll: 1,
                                                        numberOfItemsToShow: 1,
                                                        scrollDirection: .horizontal)
        self.cvEvents.configureForPeekingBehavior(behavior: behavior)
        self.cvEvents.reloadData()
    }
}

// MARK: - Extensions
extension EventListTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(data: self.eventList[indexPath.item])
        return cell
    }
}

extension EventListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(eventList[indexPath.item])")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
