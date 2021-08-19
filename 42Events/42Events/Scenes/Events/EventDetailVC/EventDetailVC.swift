//
//  EventDetailVC.swift
//  42Events
//
//  Created by Duy Nguyen on 06/06/2021.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class EventDetailVC: BaseViewController, BindableType {
    // MARK: - ViewModel
    internal var viewModel: EventDetailVM!

    // MARK: - Instance
    public static func instance() -> EventDetailVC {
        let vc = EventDetailVC()
        return vc
    }
    
    // MARK: - VARIABLES
    private var webView: WKWebView!
    private let viewDidLoadTrigger = PublishSubject<Void>()
    private let networkConnectionTrigger = PublishSubject<Void>()
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initNavigationBar()
    }
    
    override func localizeContent() {
        super.localizeContent()
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        networkConnectionTrigger.onNext(())
        networkConnectionTrigger.onCompleted()
    }
    
    // MARK: - FUNCTIONS
    func bindViewModel() {
        let input = EventDetailVM.Input(intialLoad: viewDidLoadTrigger,
                                        networkConnectionRestored: networkConnectionTrigger)
        let output = viewModel.transform(input: input)
        
        // WebView configuration
        output.webViewConfig
            .drive(with: self, onNext: { $0.initWebView(config: $1) })
            .disposed(by: disposeBag)
        
        // Load WebView
        output.detailURL
            .compactMap { $0 }
            .drive(with: self, onNext: { $0.loadWebView($1) })
            .disposed(by: disposeBag)
        
        // Loading
        let loading = webView.rx.loading.share(replay: 1, scope: .whileConnected)
        loading
            .asDriverOnErrorJustComplete()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        viewDidLoadTrigger.onNext(())
    }
    
    private func initUI() {
        
    }
    
    private func initNavigationBar() {
        self.showBackButton()
    }
    
    private func initWebView(config: WKWebViewConfiguration) {
        self.webView = WKWebView(frame: view.bounds, configuration: config)
        self.webView.requestDesktopMode()
        self.webView.allowsBackForwardNavigationGestures = true
        self.view = self.webView
    }
    
    private func loadWebView(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
}
