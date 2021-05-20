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
    @IBOutlet weak var cvEvents: UICollectionView!
    
    
    
    // MARK: - VARIABLES
    private var sportType: String = ""
    private var viewType: ViewType = .events
    private var events: [Event] = []
    private var refreshControl = UIRefreshControl()
    private lazy var flowLayout: DynamicHeightFlowLayout = {
        let layout = DynamicHeightFlowLayout()
        layout.sectionInsetReference = .fromContentInset // .fromContentInset is default
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        return layout
    }()

    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        self.initCollectionView()
        self.getEventsBySportType()
    }
    
    
    // MARK: - ACTIONS
    @IBAction func didToggleMedalView(_ sender: UISwitch) {
        self.viewType = sender.isOn ? .medals : .events
        self.cvEvents.reloadData()
    }
    
    @objc private func reloadData() {
        self.getEventsBySportType()
    }
    
    
    // MARK: - FUNCTIONS
    private func initNavigationBar() {
        self.showScreenTitle("Events")
        self.showBackButton()
    }
    
    private func initCollectionView() {
        cvEvents.registerNib(EventCollectionViewCell.self)
        cvEvents.registerNib(MedalViewCollectionViewCell.self)
        cvEvents.delegate = self
        cvEvents.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        cvEvents.refreshControl = refreshControl
        cvEvents.collectionViewLayout = flowLayout
    }
    
    private func populateData(_ data: [Event]) {
        let suffix = data.count > 1 ? "events" : "event"
        self.lbEventsCount.text = "\(data.count) \(self.sportType) \(suffix)"
        self.events = data
        self.cvEvents.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func getEventsBySportType() {
        EventsApi.shared.getEvents(sportType: self.sportType) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let events):
                self.populateData(events)
            case .failure(let error):
                AppDialog.withOk(controller: self, title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
}

// MARK: - EXTENSIONS
extension EventsFilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewType {
        case .events:
            let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCell(data: events[indexPath.row])
            return cell
        case .medals:
            let cell: MedalViewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCell(data: events[indexPath.row])
            return cell
        }
    }
}

extension EventsFilterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped \(events[indexPath.item])")
    }
}
