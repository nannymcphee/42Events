//
//  Setting.swift
//  42Events
//
//  Created by Duy Nguyen on 19/07/2021.
//

import UIKit

public struct Setting {
    public var id, name: String
    public var image: UIImage?
    public var actionType: ActionSettingType
    
    public init() {
        self.id = ""
        self.name = ""
        self.image = nil
        self.actionType = .login
    }
}

public enum ActionSettingType {
    case login
    case signUp
    case faq
    case contactUs
    case language
}

extension Setting {
    public init(actionType: ActionSettingType, image: UIImage?) {
        self.init()
        self.id = actionType.id
        self.name = actionType.title
        self.image = image
        self.actionType = actionType
    }
}

extension ActionSettingType {
    public var id: String {
        switch self {
        case .login:
            return "login"
        case .signUp:
            return "signup"
        case .faq:
            return "faq"
        case .contactUs:
            return "contact"
        case .language:
            return "language"
        }
    }
    
    public var title: String {
        switch self {
        case .login:
            return "Login"
        case .signUp:
            return Text.signUp
        case .faq:
            return Text.guidesAndFaq
        case .contactUs:
            return Text.contactUs
        case .language:
            return Text.language
        }
    }
}


