//
//  KeyedDecodingContainer+decodeWrapper.swift
//  e-stay
//
//  Created by ThanhPhong-Tran on 9/17/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decodex<T>(key: K, defaultValue: T) -> T
        where T : Decodable {
            return (try? decode(T.self, forKey: key)) ?? defaultValue
    }
}
