//
//  SecondViewController.swift
//  FleetPod
//
//  Created by Steve Sheets on 4/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import FleetIOSPod

class SecondViewController: FleetViewController {
    
    @IBAction func backAction(_ sender: Any) {
        g_fleet_root_view_controller?.pop()
    }

}
