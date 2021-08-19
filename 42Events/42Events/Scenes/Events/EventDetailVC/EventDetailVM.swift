//
//  EventDetailVM.swift
//  42Events
//
//  Created by Duy Nguyen on 18/06/2021.
//

import WebKit
import RxSwift
import RxCocoa
import FTDomain

class EventDetailVM: BaseVM, ViewModelType, EventPublisherType {
    init(eventModel: EventModel) {
        self.eventModel = eventModel
    }
    
    // MARK: Inputs
    struct Input {
        let intialLoad: Observable<Void>
        let networkConnectionRestored: Observable<Void>
    }
    
    // MARK: Outputs
    struct Output {
        let event: EventModel
        let webViewConfig: Driver<WKWebViewConfiguration>
        let detailURL: Driver<URL?>
    }
    
    // MARK: Event
    enum Event {
        case dismiss
    }
    
    // MARK: Public variables
    public var eventPublisher = PublishSubject<Event>()
    public var eventModel: EventModel
    
    // MARK: Private variables
    private let webViewConfigRelay = BehaviorRelay<WKWebViewConfiguration>(value: WKWebViewConfiguration())
    private let webViewUrlRelay = BehaviorRelay<URL?>(value: nil)
    
    // MARK: Public functions
    func transform(input: Input) -> Output {
        // Intial load & Network connection restored
        Observable.merge(input.intialLoad, input.networkConnectionRestored)
            .subscribe(with: self, onNext: { viewModel, _ in
                viewModel.initWebViewConfiguration()
                viewModel.initDetailURL()
            })
            .disposed(by: disposeBag)
        
        return Output(event: eventModel,
                      webViewConfig: webViewConfigRelay.asDriver(),
                      detailURL: webViewUrlRelay.asDriver())
    }
    
    // MARK: Privates functions
    private func initWebViewConfiguration() {
        let contentController = WKUserContentController()
        let headerClass = eventModel.sportType == .running ? "dashboard-header" : "home-header-main"
        let footerClass = "box-footer"
        let divIds = [headerClass, footerClass]
        self.removeDiv(ids: divIds, contentController: contentController)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webViewConfigRelay.accept(config)
    }
    
    private func removeDiv(ids: [String], contentController: WKUserContentController) {
        let scripts = ids.map { "document.querySelector('.\($0)').remove();" }
        let userScripts = scripts.map { WKUserScript(source: $0 as String, injectionTime: .atDocumentEnd, forMainFrameOnly: false) }
        userScripts.forEach { contentController.addUserScript($0) }
    }
    
    private func initDetailURL() {
        let path = eventModel.sportType == .running ? "race" : "race-bundle"
        self.webViewUrlRelay.accept(URL(string: AppConstants.detailUrl + "/\(path)/\(eventModel.id)"))
    }
}
