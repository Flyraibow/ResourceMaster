//
//  AppDelegate.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/5/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

