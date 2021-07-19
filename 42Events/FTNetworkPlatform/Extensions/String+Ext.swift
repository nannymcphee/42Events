//
//  String+Ext.swift
//  FTNetworkPlatform
//
//  Created by Duy Nguyen on 19/07/2021.
//

import Foundation

extension String {
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
