//
//  TPLog.swift
//  TPNManager
//
//  Created by ThanhPhong-Tran on 5/27/18.
//  Copyright © 2018 ECDC. All rights reserved.
//

import Foundation

public class XLog {
    
    public static let TAG: String = "X-Logger"
    #if DEBUG
    private static let isDebug = true
    #else
    private static let isDebug = false
    #endif
    
    public static func print(_ object: Any?,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        self.print(tag: TAG, message: String(describing: object ?? "nil"), file: file, function: function, line: line)
    }
    
    public static func print(tag: String?,
                             message: String?,
                             file: String = #file,
                             function: String = #function,
                             line: Int = #line) {
        if isDebug {
            let filename = (file as NSString).lastPathComponent
            
            NSLog("%@:%@ %@ - %@: %@", filename, line.toString, function, tag ?? TAG, message ?? "")
        }
    }
}
