//
//  EventsListView.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class EventsListView: BaseView {
    enum Event {
        case didSelectEvent(EventModel)
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvEvents: EventsRxCollectionView!
    
    // MARK: - Variables
    private var viewModel: EventListViewVM!
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
        view.viewModel = EventListViewVM(events: events)
        view.sectionTitle = sectionTitle
        view.sectionId = sectionId
        view.bindViewModel()
        return view
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func populateData(with events: [EventModel]) {
        self.viewModel.updateEvents(events)
        self.lbTitle.text = self.sectionTitle?.localized
    }
    
    public override func updateLocalize() {
        super.updateLocalize()
        self.lbTitle.text = self.sectionTitle?.localized
        self.cvEvents.reloadData()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func configureView() {

    }
    
    private func bindViewModel() {
        let input = EventListViewVM.Input()
        let output = viewModel.transform(input: input)
        let dataSource = self.cvEvents.dataSource()
        
        output.eventModels
            .drive(cvEvents.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        cvEvents.rx
            .modelSelected(EventCellItem.self)
            .asObservable()
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                
                switch item {
                case .event(let viewModel, _):
                    self.eventPublisher.onNext(.didSelectEvent(viewModel.item))
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
