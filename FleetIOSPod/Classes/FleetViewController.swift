//
//  FleetViewController.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/15/19.
//

import UIKit

// MARK: Class

/// View Controller for Fleet
open class FleetViewController: UIViewController {
    
    // MARK: Abstract Methods
    
    /// Abstract call invoked on the new incoming to ccntainer view controller.
    //  It will be passed outgoing view controller. So data can be passed.
    //  This is an alternative to using the fillBlock closure.
    ///
    /// - Parameter outgingController: UIViewController being removed from container
    public func fillData(outgingController: UIViewController) {
        
    }
    
    /// Abstract call invoked on the old outgoing to ccntainer view controller.
    //  It will be passed incoming view controller. So data can be passed.
    //  This is an alternative to using the fillBlock closure.
    ///
    /// - Parameter incomingController: UIViewController being added from container
    public func fillData(incomingController: UIViewController) {
        
    }
}

// MARK: Extension

extension UIViewController {
    
    // MARK: Public Methods
    
    /// Returns an Label with given referral id
    ///
    /// - Parameter tag: int with tag of View
    /// - Returns: Returns Button with given name
    public func findContainerElement(with tag: Int) -> FleetContainerView? {
        return view.viewWithTag(tag) as? FleetContainerView
    }
    
}
