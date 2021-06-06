//
//  EventsFilterVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

class EventsFilterVC: BaseViewController {
    enum ViewType {
        case events
        case medals
    }
    
    // MARK: - Instance
    public static func instanceWithNavController(sportType: String) -> UINavigationController {
        let vc = EventsFilterVC()
        vc.sportType = sportType
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var lbEventsCount: UILabel!
    @IBOutlet weak var swMedalView: UISwitch!
    @IBOutlet weak var lbMedalView: UILabel!
    @IBOutlet weak var tbEvents: UITableView!
    
    
    // MARK: - VARIABLES
    private var sportType: String = ""
    private var viewType: ViewType = .events
    private var events: [Event] = []

    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initNavigationBar()
        self.initTableView()
        self.getEventsBySportType()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.initNavigationBar()
        let suffix = events.count > 1 ? Text.events.localized.lowercased() : Text.event.localized.lowercased()
        self.lbEventsCount.text = "\(events.count) \(self.sportType.localized) \(suffix)"
        self.lbMedalView.text = Text.medalView.localized
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        self.getEventsBySportType()
    }
    
    // MARK: - ACTIONS
    @IBAction func didToggleMedalView(_ sender: UISwitch) {
        self.viewType = sender.isOn ? .medals : .events
        self.tbEvents.reloadData()
    }
    
    @objc override func reloadData() {
        self.getEventsBySportType()
    }
    
    
    // MARK: - FUNCTIONS
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
        tbEvents.delegate = self
        tbEvents.dataSource = self
        tbEvents.estimatedRowHeight = 200
        tbEvents.rowHeight = UITableView.automaticDimension
        
        tbEvents.refreshControl = refreshControl
    }
    
    private func populateData(_ data: [Event]) {
        let suffix = data.count > 1 ? Text.events.localized.lowercased() : Text.event.localized
        self.lbEventsCount.text = "\(data.count) \(self.sportType.localized) \(suffix)"
        self.events = data
        self.tbEvents.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func getEventsBySportType() {
        EventsApi.shared.getEvents(sportType: self.sportType) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let events):
                self.populateData(events)
            case .failure:
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}

// MARK: - EXTENSIONS
extension EventsFilterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewType {
        case .events:
            let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(data: events[indexPath.row])
            return cell
        case .medals:
            let cell: MedalViewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(data: events[indexPath.row])
            return cell
        }
    }
}

extension EventsFilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventDetailVC.instanceWithNavController(event: events[indexPath.item])
        self.present(vc, animated: true, completion: nil)
    }
}
