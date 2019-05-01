//
//  ViewController.swift
//  FleetPod
//
//  Created by Steve Sheets on 04/15/2019.
//  Copyright (c) 2019 Steve Sheets. All rights reserved.
//

import UIKit
import FleetIOSPod

class ExampleViewController: FleetViewController {

    @IBAction func gotoAction(_ sender: Any) {
        g_fleet_root_view_controller?.push(name: "second")
    }
    
}

