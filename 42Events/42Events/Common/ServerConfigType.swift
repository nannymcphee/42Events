//
//  ServerConfigType.swift
//  42Events
//
//  Created by Duy Nguyen on 19/07/2021.
//

import Foundation

public protocol ServerConfigType {
    var serverUrl: URL { get }
    var detailURL: URL { get }
}

public class ServerConfig: ServerConfigType {
    public init(
        serverUrl: URL,
        detailURL: URL,
        environment: EnvironmentType) {
        
        self.serverUrl = serverUrl
        self.detailURL = detailURL
        self.environment = environment
    }
    
    public var serverUrl: URL
    public var detailURL: URL
    public var environment: EnvironmentType
    
    public static let testing = ServerConfig(
        serverUrl:          URL(string: "https://api-v2-sg-staging.42race.com/api/v1")!,
        detailURL:          URL(string: "https://d3iafmipte35xo.cloudfront.net")!,
        environment:        .testing
    )

    public static let production = ServerConfig(
        serverUrl:          URL(string: "https://api-v2-sg-staging.42race.com/api/v1")!,
        detailURL:          URL(string: "https://d3iafmipte35xo.cloudfront.net")!,
        environment:        .production
    )
}
