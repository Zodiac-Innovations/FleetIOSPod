//
//  FleetAppDelegate.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/15/19.
//

import UIKit

// MARK: Globals

public var g_fleet_app_delegate: FleetAppDelegate? = nil

// MARK: Class

/// App Delegate class for Fleet
open class FleetAppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Lifecycle
    
    public override init() {
        super.init()
        
        g_fleet_app_delegate = self
    }
    
    // MARK: Abstract Methods
    
    /// Abstract class at start of app (before animation)
    public func appBegin() {
    }
    
}
