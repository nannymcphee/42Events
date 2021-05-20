//
//  BaseVC.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: - VARIABLES
    private let BTN_BACK_WIDTH: CGFloat = 36
    
    //MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDefaultNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - PRIVATE FUNCTIONS
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
    
    public func getIconBarButtonItem(icon: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: BTN_BACK_WIDTH, height: BTN_BACK_WIDTH)
        button.setImage(icon, for: .normal)
        button.tintColor = AppColors.black
        return UIBarButtonItem(customView: button)
    }
    
    //MARK: - ACTIONS
    @objc func backButtonPressed(_ sender: UIBarButtonItem)  {
        self.navigationController?.popViewController(animated: true)
    }
}

