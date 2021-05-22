//
//  TPNCache.swift
//  WC2018
//
//  Created by ThanhPhong-Tran on 5/30/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

public class XCache {
    
    private let userDefault = UserDefaults.standard
    private let serializer = XSerializer()
    
    public func save<T: Codable>(object: T, forKey key: String) {
        guard let data: Data = serializer.serializeData(data: object) else { return }
        userDefault.set(data, forKey: key)
    }
    
    public func save(data: Data, forKey key: String) {
        userDefault.set(data, forKey: key)
    }
    
    public func getData<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefault.data(forKey: key) else { return nil }
        return serializer.serializeJson(data: data)
    }
}
