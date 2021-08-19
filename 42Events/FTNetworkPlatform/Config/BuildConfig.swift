//
//  BuildConfig.swift
//  FTNetworkPlatform
//
//  Created by Duy Nguyen on 19/07/2021.
//

import Foundation

public struct BuildConfig {
    
    public var baseURL: URL
    public var detailURL: URL
    public var token: String?
    
    public init(baseURL: URL, detailURL: URL, token: String? = nil) {
        self.baseURL = baseURL
        self.detailURL = detailURL
        self.token = token
    }
    
    static var `default` = BuildConfig(
        baseURL: URL(string: "https://api-v2-sg-staging.42race.com/api/v1")!,
        detailURL: URL(string: "https://d3iafmipte35xo.cloudfront.net")!,
        token: nil
    )
}
