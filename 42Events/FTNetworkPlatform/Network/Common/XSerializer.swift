//
//  TPSerializer.swift
//  TPNManager
//
//  Created by ThanhPhong-Tran on 5/27/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

protocol TPSerializable {
    func serializeJson<T: Codable>(data: Data) -> T?
    func serializeData<T: Codable>(data: T) -> Data?
}

public class XSerializer: TPSerializable {
    
    func serializeJson<T: Codable>(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func serializeData<T: Codable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}
