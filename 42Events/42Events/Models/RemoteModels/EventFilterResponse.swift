//
//  EventFilterResponse.swift
//  42Events
//
//  Created by Nguyên Duy on 20/05/2021.
//

import Foundation

struct EventFilterResponse: Codable {
    let code: Int
    let totalData: Int
    let totalPagination: Int
    let cachedData: Bool
    let data: [Event]
}
