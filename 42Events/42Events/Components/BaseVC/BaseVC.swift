//
//  BaseVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit
import Reachability
import Localize_Swift

class BaseViewController: UIViewController {
    //MARK: - VARIABLES
    private let BTN_BACK_WIDTH: CGFloat = 36
    private let reachability = try? Reachability()
    
    public var isSwipeBackEnabled: Bool = false {
        didSet {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isSwipeBackEnabled
        }
    }
    
    //MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.localizeContent()
        self.initDefaultNavigationBar()
    }
    
    deinit {
        self.removeObservers()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func addObservers() {
        // Localization
        NotificationCenter.default.addObserver(self, selector: #selector(localizeContent), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        // Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    private func removeObservers() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initDefaultNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = .white
        navigationBar?.isTranslucent = false
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func showBackButton() {
        let btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: BTN_BACK_WIDTH, height: BTN_BACK_WIDTH)
        btnBack.setImage(#imageLiteral(resourceName: "icBack"), for: .normal)
        btnBack.tintColor = AppColors.black
        btnBack.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let leftBar = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    public func showScreenTitle(_ title: String) {
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        lbTitle.font = fontScheme.extraBold16
        lbTitle.textAlignment = .center
        lbTitle.text = title
        self.navigationItem.titleView = lbTitle
    }
    
    public func getIconBarButtonItem(icon: UIImage?, target: UIViewController, action: Selector?) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: icon, style: .plain, target: target, action: action)
        barButton.tintColor = AppColors.black
        return barButton
    }
    
    public func onNetworkConnectionRestored() {}
    
    //MARK: - ACTIONS
    @objc func backButtonPressed(_ sender: UIBarButtonItem)  {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            if navigation.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func localizeContent() {}
        
    @objc private func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi, .cellular:
            self.onNetworkConnectionRestored()
        case .unavailable, .none:
            AppDialog.withOk(controller: self, title: Text.error.localized, message: Text.networkConnectionAlertMessage.localized)
        }
    }
}

