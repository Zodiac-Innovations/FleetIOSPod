//
//  Fleet.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/15/19.
//  Copyright (c) 2019 Steve Sheets. All rights reserved.
//

import UIKit

// MARK: Class

/// Abstract class with version information for Library
public class Fleet {
    
    // MARK: Class Methods
    
    /// Version Number of Library
    public class func versionNumber() -> Int {
        return 1
    }
    
    /// Version of Library
    public class func version() -> String {
        return "1.0.0"
    }

    /// Main Storyboard Name
    public class var storyboardName: String {
        return "Main"
    }
}
