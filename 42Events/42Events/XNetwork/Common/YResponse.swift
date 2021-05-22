//
//  YResponse.swift
//  Netalo
//
//  Created by Nhu Nguyet on 5/28/20.
//  Copyright © 2020 'Netalo'. All rights reserved.
//

import UIKit

public class YResponse<T: Codable>: Codable {
    public var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = values.decodex(key: .data, defaultValue: nil)
    }
}
