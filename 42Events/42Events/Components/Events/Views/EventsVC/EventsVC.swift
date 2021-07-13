//
//  EventsVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ImageSlideshow

class EventsVC: BaseViewController, BindableType {
    // MARK: - ViewModel
    internal var viewModel: EventsVM!

    // MARK: - Instantiate
    static func instantiate() -> EventsVC {
        let vc = EventsVC(nibName: "EventsVC", bundle: Bundle(for: EventsVC.self))
        return vc
    }
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var vStackEventList: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vSlideshow: ImageSlideshow!
    @IBOutlet weak var vSportTypeListContainer: UIView!
    
    // MARK: - VARIABLES
    private var eventListViews = [EventsListView]()
    private let sportTypeListViewVM = SportTypeListViewVM()
    private var sportTypeListView: SportTypeListView?
    
    private let settingsTrigger = PublishSubject<Void>()
    private let sportTypeTrigger = PublishSubject<String>()
    private let selectTrigger = PublishSubject<EventModel>()
    private let slideshowSelectTrigger = PublishSubject<Int>()
    private let viewDidLoadTrigger = PublishSubject<Void>()
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefreshControl()
        self.initSlideshow()
        self.initSportTypeListView()
    }
    
    override func localizeContent() {
        super.localizeContent()
        self.initNavigationBar()
        self.sportTypeListView?.updateLocalize()
        self.eventListViews.forEach { $0.updateLocalize() }
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        self.refreshTrigger.onNext(())
    }
    
    // MARK: - ACTIONS
    @objc private func didTapNotificationButton() {
        
    }
    
    @objc private func didTapMenuButton() {
        let vc = SettingsVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - FUNCTIONS
    func bindViewModel() {
        let input = EventsVM.Input(initialLoad: viewDidLoadTrigger.asObservable(),
                                   refresh: refreshTrigger.asObservable(),
                                   settingSelected: settingsTrigger.asObservable(),
                                   sportTypeSelected: sportTypeListViewVM.action.didSelectSportType,
                                   itemSelected: selectTrigger.asObservable(),
                                   slideshowSelected: slideshowSelectTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // Featured events
        output.featuredEvents
            .drive(onNext: { [weak self] events in
                guard let self = self else { return }
                let imageSource = events.compactMap { KingfisherSource(urlString: $0.bannerCard) }
                self.vSlideshow.setImageInputs(imageSource)
            })
            .disposed(by: disposeBag)
        
        // Starting soon, popular, new release, free, past events
        output.sections
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.initEventListViews(sections: sections)
                for section in sections {
                    if let view = self.eventListViews.first(where: { $0.sectionId == section.id }) {
                        view.populateData(with: section.data)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // Pull to refresh
        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible, self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        self.viewDidLoadTrigger.onNext(())
    }
    
    private func initNavigationBar() {
        self.showScreenTitle(Text.events.localized)
        
        let btnNoti = self.getIconBarButtonItem(icon: #imageLiteral(resourceName: "ic_bell"), target: self, action: #selector(didTapNotificationButton))
        self.navigationItem.leftBarButtonItem = btnNoti
        
        let btnMenu = self.getIconBarButtonItem(icon: #imageLiteral(resourceName: "ic_menu"), target: self, action: nil)
        btnMenu.rx.tap
            .asObservable()
            .bind(to: settingsTrigger)
            .disposed(by: disposeBag)
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
        
        // Slideshow tap event
        vSlideshow.rx
            .tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .map { (owner, _) -> Int in
                return owner.vSlideshow.currentPage
            }
            .bind(to: slideshowSelectTrigger)
            .disposed(by: disposeBag)
    }
    
    private func initSportTypeListView() {
        self.sportTypeListView = SportTypeListView.instance(viewModel: sportTypeListViewVM)
        self.vSportTypeListContainer.addSubview(self.sportTypeListView!)
        self.sportTypeListView?.layoutAttachAll(to: self.vSportTypeListContainer)
    }
    
    private func initRefreshControl() {
        scrollView.refreshControl = refreshControl
    }
    
    private func initEventListViews(sections: [EventSection]) {
        guard eventListViews.isEmpty else { return }
        
        for section in sections {
            let view = EventsListView.instance(with: section.data, sectionTitle: section.title, sectionId: section.id)
            
            view.eventPublisher
                .map { (event) -> EventsVM.Event in
                    switch event {
                    case .didSelectEvent(let eventModel):
                        return .presentEventDetail(eventModel)
                    }
                }
                .bind(to: self.viewModel.eventPublisher)
                .disposed(by: disposeBag)
            
            eventListViews.append(view)
        }
        
        self.eventListViews.forEach { vStackEventList.addArrangedSubview($0) }
    }
}

// MARK: - EXTENSIONS
