//
//  EventDetailVC.swift
//  42Events
//
//  Created by Duy Nguyen on 06/06/2021.
//

import UIKit
import WebKit

class EventDetailVC: BaseViewController {
    // MARK: - Instance
    public static func instanceWithNavController(event: Event) -> UINavigationController {
        let vc = EventDetailVC()
        vc.event = event
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    // MARK: - IBOUTLETS
    
    
    // MARK: - VARIABLES
    private var event: Event!
    private var webView: WKWebView!
    private let contentController = WKUserContentController()

    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initWebView()
        self.initNavigationBar()
    }
    
    override func localizeContent() {
        super.localizeContent()
    }
    
    override func onNetworkConnectionRestored() {
        super.onNetworkConnectionRestored()
        self.loadWebView(event: self.event)
    }
    
    // MARK: - ACTIONS
    
    
    // MARK: - FUNCTIONS
    private func initUI() {
        
    }
    
    private func initNavigationBar() {
        self.showBackButton()
    }
    
    private func initWebView() {
        // Hide header & footer div
        let headerClass = event.sportType == .running ? "dashboard-header" : "home-header-main"
        let footerClass = "box-footer"
        let divIds = [headerClass, footerClass]
        self.removeDiv(ids: divIds)
        
        // Init WebView configuration
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        self.webView = WKWebView(frame: view.bounds, configuration: config)
        self.webView.requestDesktopMode()
        self.view = self.webView
        self.loadWebView(event: self.event)
    }
    
    private func loadWebView(event: Event) {
        let path = event.sportType == .running ? "race" : "race-bundle"
        guard let url = URL(string: "https://d3iafmipte35xo.cloudfront.net/\(path)/\(event.id)") else {
            AppDialog.withOk(controller: self, title: Text.error.localized, message: Text.eventDetailLoadFailedAlertMessage.localized)
            return
        }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func removeDiv(ids: [String]) {
        let scripts = ids.map { "document.querySelector('.\($0)').remove();" }
        let userScripts = scripts.map { WKUserScript(source: $0 as String, injectionTime: .atDocumentEnd, forMainFrameOnly: false) }
        userScripts.forEach { contentController.addUserScript($0) }
    }
}
