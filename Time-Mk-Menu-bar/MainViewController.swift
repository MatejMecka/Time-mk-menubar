//
//  MainViewController.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/25/20.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import AppKit

class MainViewController: NSViewController {
    override func viewDidAppear()
    {
        super.viewDidAppear()

        // You can use a notification and observe it in a view model where you want to fetch the data for your SwiftUI view every time the popover appears.
        // NotificationCenter.default.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
}
