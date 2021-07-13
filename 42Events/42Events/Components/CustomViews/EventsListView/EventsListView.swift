//
//  EventsListView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import MSPeekCollectionViewDelegateImplementation

protocol EventsListViewDelegate: class {
    func didSelectEvent(_ event: EventModel)
}

class EventsListView: BaseView {
    enum Event {
        case didSelectEvent(EventModel)
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvEvents: UICollectionView!
    
    // MARK: - Variables
    private var behavior: MSCollectionViewPeekingBehavior!
    private var events = [EventModel]()
    private var sectionTitle: String?
    
    public var sectionId: String = ""
    public var eventPublisher = PublishSubject<Event>()

    // MARK: - OVERRIDES
    override func awakeFromNib() {
        configureView()
    }
        
    
    // MARK: - PUBLIC FUNCTIONS
    static func instance(with events: [EventModel], sectionTitle: String?, sectionId: String = "") -> EventsListView {
        let nib = UINib(nibName: "EventsListView", bundle: Bundle(for: EventsListView.self))
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? EventsListView else {
            return EventsListView()
        }
        view.events = events
        view.sectionTitle = sectionTitle
        view.sectionId = sectionId
        view.populateData(with: events)
        return view
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func populateData(with events: [EventModel]) {
        self.events = events
        self.lbTitle.text = self.sectionTitle?.localized
        self.behavior = MSCollectionViewPeekingBehavior(cellSpacing: 10,
                                                        cellPeekWidth: 20,
                                                        maximumItemsToScroll: 1,
                                                        numberOfItemsToShow: 1,
                                                        scrollDirection: .horizontal)
        self.cvEvents.configureForPeekingBehavior(behavior: behavior)
        self.cvEvents.reloadData()
    }
    
    public override func updateLocalize() {
        super.updateLocalize()
        self.lbTitle.text = self.sectionTitle?.localized
        self.cvEvents.reloadData()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func configureView() {
        self.initCollectionView()
    }
    
    private func initCollectionView() {
        self.cvEvents.registerNib(EventCollectionViewCell.self)
        self.cvEvents.delegate = self
        self.cvEvents.dataSource = self
    }
}

// MARK: - Extensions
extension EventsListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(data: self.events[indexPath.item])
        return cell
    }
}

extension EventsListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.eventPublisher.onNext(.didSelectEvent(events[indexPath.item]))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
