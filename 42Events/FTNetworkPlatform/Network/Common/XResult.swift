//
//  XResult.swift
//  Netalo
//
//  Created by Tran Phong on 7/15/19.
//  Copyright © 2019 'Netalo'. All rights reserved.
//

import Foundation

public enum XResult<T>{
    case success(T)
    case failure(XError)
}

public typealias XPagingResult<T: Codable>   = XResult<XPagingData<T>>

