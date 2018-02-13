//
//  ViewController.swift
//  TestSwift
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var labPath: NSTextField!
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    ResourceManager.sharedInstance.checkingDefaultSettings();
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    let folderPath = String(describing: notification.object!)
    labPath.stringValue = folderPath
  }
  
  @IBAction func clickRefresherButton(_ sender: Any) {
    if (ResourceManager.sharedInstance.rootPath == nil) {
      ResourceManager.sharedInstance.chooseRootFolder()
    } else {
      // TODO: Referesh the selected root folder
    }
  }
  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}

