//
//  EventsFilterVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import FTDomain

class EventsFilterVC: BaseViewController, BindableType {
    enum ViewType {
        case events
        case medals
    }
    
    internal var viewModel: EventsFilterVM!
    
    // MARK: - Instance
    public static func instance() -> EventsFilterVC {
        let vc = EventsFilterVC()
        return vc
    }
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var lbEventsCount: UILabel!
    @IBOutlet weak var swMedalView: UISwitch!
    @IBOutlet weak var lbMedalView: UILabel!
    @IBOutlet weak var tbEvents: UITableView!
    
    // MARK: - VARIABLES
    private var viewType: ViewType = .events
    private var events: [EventModel] = []
    private let viewDidLoadTrigger = PublishSubject<Void>()
    private let networkConnectionTrigger = PublishSubject<Void>()
    private let itemSelectedTrigger = PublishSubject<EventModel>()

    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initNavigationBar()
        self.initTableView()
        self.bindingUI()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.initNavigationBar()
        let suffix = events.count > 1 ? Text.events.localized.lowercased() : Text.event.localized.lowercased()
        self.lbEventsCount.text = "\(events.count) \(self.viewModel.sportType.localized) \(suffix)"
        self.lbMedalView.text = Text.medalView.localized
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        self.networkConnectionTrigger.onNext(())
        self.networkConnectionTrigger.onCompleted()
    }
    
    
    // MARK: - FUNCTIONS
    func bindViewModel() {
        let input = EventsFilterVM.Input(initialLoad: viewDidLoadTrigger,
                                         networkConnectionRestored: networkConnectionTrigger,
                                         refresh: refreshTrigger,
                                         medalViewToggle: swMedalView.rx.isOn.asObservable(),
                                         itemSelected: itemSelectedTrigger)
        let output = viewModel.transform(input: input)
        
        // Events
        output.events
            .drive(tbEvents.rx.items) { [weak self] (tableView, index, event) in
                guard let self = self else { return UITableViewCell() }
                let indexPath = IndexPath(row: index, section: 0)
                switch self.viewType {
                case .events:
                    let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configureCell(data: event)
                    return cell
                case .medals:
                    let cell: MedalViewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configureCell(data: event)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        // Count label's text
        output.events
            .map { $0.count }
            .drive(with: self, onNext: { $0.setEventsCountLabel($1) })
            .disposed(by: disposeBag)
        
        // Medal view trigger
        output.isMedalView
            .drive(with: self, onNext: { viewController, isMedalView in
                viewController.viewType = isMedalView ? .medals : .events
                viewController.tbEvents.reloadData()
            })
            .disposed(by: disposeBag)
        
        // Pull to refresh
        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible, self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        self.viewDidLoadTrigger.onNext(())
        
        viewDidLoadTrigger.onNext(())
    }
    
    private func initUI() {
        self.swMedalView.onTintColor = AppColors.red
    }
    
    private func initNavigationBar() {
        self.showScreenTitle(Text.events.localized)
        self.showBackButton()
    }
    
    private func initTableView() {
        tbEvents.registerNib(EventTableViewCell.self)
        tbEvents.registerNib(MedalViewTableViewCell.self)
        tbEvents.estimatedRowHeight = 200
        tbEvents.rowHeight = UITableView.automaticDimension
        tbEvents.refreshControl = refreshControl
    }
    
    private func setEventsCountLabel(_ count: Int) {
        let suffix = count > 1 ? Text.events.localized.lowercased() : Text.event.localized
        self.lbEventsCount.text = "\(count) \(self.viewModel.sportType.localized) \(suffix)"
    }
    
    private func bindingUI() {
        // Event selected
        tbEvents.rx
            .modelSelected(EventModel.self)
            .bind(to: itemSelectedTrigger)
            .disposed(by: disposeBag)
    }
}
