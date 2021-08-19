//
//  AppConstants.swift
//  42Events
//
//  Created by Nguyên Duy on 21/05/2021.
//

import FTDomain

class AppConstants {
    static var serverUrl: String = "https://api-v2-sg-staging.42race.com/api/v1"
    static var detailUrl: String = "https://d3iafmipte35xo.cloudfront.net"
    
    static var languages = [
        Language(code: "en",        name: "English"),
        Language(code: "zh-Hans",   name: "简体 中文"),
        Language(code: "zh-Hant",   name: "繁體 中文"),
        Language(code: "id",        name: "Bahasa Indonesia"),
        Language(code: "th",        name: "ภาษา ไทย"),
        Language(code: "vi",        name: "Tiếng Việt"),
    ]
}
