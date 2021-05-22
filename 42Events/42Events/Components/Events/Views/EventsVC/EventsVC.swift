//
//  EventsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import ImageSlideshow

class EventsVC: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var vStackEventList: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vSlideshow: ImageSlideshow!
    @IBOutlet weak var vSportTypeListContainer: UIView!
    
    private struct Section {
        var id: String
        var title: String?
        var data: [Event]
    }
    
    // MARK: - VARIABLES
    private var sectionList = [
        Section(id: "startingSoon", title: Text.startingSoon,   data: []),
        Section(id: "popular",      title: Text.popular,        data: []),
        Section(id: "newRelease",   title: Text.newRelease,     data: []),
        Section(id: "free",         title: Text.free,           data: []),
        Section(id: "past",         title: Text.pastEvents,     data: []),
    ]
    
    private var eventListViews: [EventsListView] = []
    private var sportTypeListView: SportTypeListView?
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initRefreshControl()
        self.initSlideshow()
        self.initSportTypeListView()
        self.initEventListViews()
        self.getListEvents()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.initNavigationBar()
        self.sportTypeListView?.updateLocalize()
        self.eventListViews.forEach { $0.updateLocalize() }
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
    
    @objc override func reloadData() {
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
    
    private func initSlideshow() {
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = AppColors.red
        pageIndicator.pageIndicatorTintColor = AppColors.lightGray
        vSlideshow.pageIndicator = pageIndicator
        vSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        vSlideshow.slideshowInterval = 5.0
        vSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
    }
    
    private func initSportTypeListView() {
        self.sportTypeListView = SportTypeListView.instance(with: self)
        self.vSportTypeListContainer.addSubview(self.sportTypeListView!)
        self.sportTypeListView?.layoutAttachAll(to: self.vSportTypeListContainer)
    }
    
    private func initRefreshControl() {
        scrollView.refreshControl = refreshControl
    }
    
    private func initEventListViews() {
        for section in sectionList {
            let view = EventsListView.instance(with: section.data, sectionTitle: section.title, sectionId: section.id, delegate: self)
            eventListViews.append(view)
        }
        self.eventListViews.forEach { self.vStackEventList.addArrangedSubview($0) }
    }
    
    private func populateData(with response: EventListResponse) {
        // Featured
        let imageSource = response.featured.compactMap { KingfisherSource(urlString: $0.bannerCard) }
        self.vSlideshow.setImageInputs(imageSource)
        
        // Starting soon, popular, New release, Free, Past events
        let mirror = Mirror(reflecting: response)
        let mirrorChildren = mirror.children.filter { $0.label != "id" && $0.label != "updatedAt" && $0.label != "featured" }
        for child in mirrorChildren {
            if let view = self.eventListViews.first(where: { $0.sectionId == child.label }) {
                view.populateData(with: child.value as! [Event])
            }
        }
    }
    
    private func getListEvents() {
        EventsApi.shared.getAllEvents { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let eventListResponse):
                self.populateData(with: eventListResponse)
                
            case .failure:
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - EXTENSIONS
extension EventsVC: SportTypeListViewDelegate {
    func didSelectSportType(_ type: String) {
        let vc = EventsFilterVC.instanceWithNavController(sportType: type)
        self.present(vc, animated: true, completion: nil)
    }
}

extension EventsVC: EventsListViewDelegate {
    func didSelectEvent(_ event: Event) {
        print("didSelectEvent: \(event)")
    }
}
