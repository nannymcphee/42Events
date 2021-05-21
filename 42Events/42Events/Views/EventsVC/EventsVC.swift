//
//  EventsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

class EventsVC: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var tbContents: UITableView!
    
    private struct Section {
        var id: String
        var title: String?
        var data: [Event]
    }
    
    // MARK: - VARIABLES
    private let refreshControl = UIRefreshControl()
    private var sections = [
        Section(id: "featured",         title: nil,                 data: []),
        Section(id: "events-filter",    title: Text.events,         data: []),
        Section(id: "starting-soon",    title: Text.startingSoon,   data: []),
        Section(id: "popular",          title: Text.popular,        data: []),
        Section(id: "new-release",      title: Text.newRelease,     data: []),
        Section(id: "free",             title: Text.free,           data: []),
    ]
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView()
        self.getListEvents()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.tbContents.reloadData()
        self.initNavigationBar()
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        self.getListEvents()
    }
    
    // MARK: - ACTIONS
    @objc private func didTapNotificationButton() {
        
    }
    
    @objc private func didTapMenuButton() {
        let vc = SettingsVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func reloadData() {
        self.getListEvents()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - FUNCTIONS
    private func initNavigationBar() {
        self.showScreenTitle(Text.events.localized)
        
        let btnNoti = self.getIconBarButtonItem(icon: #imageLiteral(resourceName: "ic_bell"), target: self, action: #selector(didTapNotificationButton))
        self.navigationItem.leftBarButtonItem = btnNoti
        
        let btnMenu = self.getIconBarButtonItem(icon: #imageLiteral(resourceName: "ic_menu"), target: self, action: #selector(didTapMenuButton))
        self.navigationItem.rightBarButtonItem = btnMenu
    }
    
    private func initTableView() {
        tbContents.registerNib(FeaturedTableViewCell.self)
        tbContents.registerNib(SportTypeTableViewCell.self)
        tbContents.registerNib(EventListTableViewCell.self)

        tbContents.delegate = self
        tbContents.dataSource = self
        tbContents.estimatedRowHeight = 200
        tbContents.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tbContents.refreshControl = refreshControl
    }
    
    private func getListEvents() {
        EventsApi.shared.getAllEvents { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let eventListResponse):
                self.sections = [
                    Section(id: "featured",     title:  nil,                data: eventListResponse.featured),
                    Section(id: "eventsFilter", title:  Text.events,        data: []),
                    Section(id: "startingSoon", title:  Text.startingSoon,  data: eventListResponse.startingSoon),
                    Section(id: "popular",      title:  Text.popular,       data: eventListResponse.popular),
                    Section(id: "newRelease",   title:  Text.newRelease,    data: eventListResponse.newRelease),
                    Section(id: "free",         title:  Text.free,          data: eventListResponse.free),
                ]
                self.tbContents.reloadData()
                
            case .failure:
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - EXTENSIONS
extension EventsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let bannerCell: FeaturedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            bannerCell.configureCell(data: sections[indexPath.section].data)
            return bannerCell
        } else if indexPath.section == 1 {
            let eventTypeCell: SportTypeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            eventTypeCell.delegate = self
            return eventTypeCell
        }
        
        let eventListCell: EventListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        eventListCell.configureCell(title: sections[indexPath.section].title, data: sections[indexPath.section].data)
        return eventListCell
    }
}

extension EventsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected indexPath: \(indexPath)")
    }
}

extension EventsVC: SportTypeTableViewCellDelegate {
    func didSelectSportType(_ type: String) {
        let vc = EventsFilterVC.instanceWithNavController(sportType: type)
        self.present(vc, animated: true, completion: nil)
    }
}
