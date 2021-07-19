//
//  EventEndPoint.swift
//  42Events
//
//  Created by Nguyên Duy on 22/05/2021.
//

import UIKit

public enum EventEndPoint {
    case getAllEvents
    case filterEvents(sportType: String, limit: Int)
}

extension EventEndPoint: EndPointType {
    public var baseURL: URL {
        return BuildConfig.default.baseURL
    }
    
    public var path: String {
        switch self {
        case .getAllEvents:
            return "/race-events"
        case .filterEvents:
            return "/race-filters"
        }
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
    
    public var timeoutInterval: Double? {
        return 30.0
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var task: HTTPTask {
        switch self {
        case .getAllEvents:
            return .request
            
        case .filterEvents(let sportType, let limit):
            var params = Parameters()
            params[JSonKeys.sportType] = sportType
            params[JSonKeys.limit] = limit
            params[JSonKeys.skipCount] = 0
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
        }
    }
}
