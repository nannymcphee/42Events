//
//  TPResponse.swift
//  TPNManager
//
//  Created by ThanhPhong-Tran on 5/27/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

public class XResponse<T: Codable>: Codable {
    public var status: Int
    public var message: String
    public var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case status = "code"
        case message = "msg"
        case data = "data"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = values.decodex(key: .status, defaultValue: -1)
        message = values.decodex(key: .message, defaultValue: "")
        data = values.decodex(key: .data, defaultValue: nil)
    }
}
