//
//  MultiplePartParameterEncoder.swift
//  NetaloUISDK
//
//  Created by Van Tien Tu on 7/29/20.
//  Copyright © 2020 'Netalo'. All rights reserved.
//

import UIKit

class MultiplePartParameterEncoder: NSObject {
    public func encode(urlRequest: inout URLRequest, with parameters: MultipartFormData) throws {
        urlRequest.httpBody = try parameters.encode()
        urlRequest.setValue("no-cache", forHTTPHeaderField: "cache-control")
        urlRequest.setValue("multipart/form-data; boundary=\(parameters.boundary)", forHTTPHeaderField: "content-type")
    }
}
