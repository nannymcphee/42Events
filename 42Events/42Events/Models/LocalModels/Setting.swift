//
//  Setting.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import UIKit

struct Setting {
    let id, name: String
    var image: UIImage?
    var actionType: ActionSettingType
    
    init(actionType: ActionSettingType, image: UIImage?) {
        self.id = actionType.id
        self.name = actionType.title
        self.image = image
        self.actionType = actionType
    }
}

public enum ActionSettingType {
    case login
    case signUp
    case faq
    case contactUs
    case language
    
    var title: String {
        switch self {
        case .login:
            return "Login"
        case .signUp:
            return "Sign up"
        case .faq:
            return "Guides and FAQ"
        case .contactUs:
            return "Contact us"
        case .language:
            return "Language"
        default:
            return ""
        }
    }
    
    var id: String {
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
        default:
            return ""
        }
    }
}
