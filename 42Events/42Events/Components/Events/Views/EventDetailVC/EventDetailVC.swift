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
    
    // MARK: - IBOUTLETS
    
    
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
    
    // MARK: - ACTIONS
    
    
    // MARK: - FUNCTIONS
    func bindViewModel() {
        let input = EventDetailVM.Input(intialLoad: viewDidLoadTrigger,
                                        networkConnectionRestored: networkConnectionTrigger)
        let output = viewModel.transform(input: input)
        
        // WebView configuration
        output.webViewConfig
            .drive(onNext: { [weak self] config in
                guard let self = self else { return }
                self.initWebView(config: config)
            })
            .disposed(by: disposeBag)
        
        // Load WebView
        output.detailURL
            .drive(onNext: { [weak self] url in
                guard let self = self, let url = url else { return }
                self.loadWebView(url)
            })
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
