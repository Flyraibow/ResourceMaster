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
  
    @IBAction func clickSelectRootFolder(_ sender: Any) {
        ResourceManager.sharedInstance.chooseRootWorkSpace()
    }
    
    @IBAction func openOneDataSet(_ sender: Any) {
        ResourceManager.sharedInstance.chooseRootWorkSpace()
    }
    @IBAction func newDataSet(_ sender: Any) {
        ResourceManager.sharedInstance.createNewWorkSpace()
    }
}

