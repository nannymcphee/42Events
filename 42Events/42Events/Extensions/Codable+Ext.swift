//
//  Codable+Ext.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import Foundation

extension KeyedDecodingContainer {
    func decodex<T>(key: K, defaultValue: T) -> T
    where T : Decodable {
        return (try? decode(T.self, forKey: key)) ?? defaultValue
    }
}
