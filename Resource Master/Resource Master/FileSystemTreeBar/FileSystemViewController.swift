//
//  LeftViewController.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class FileSystemViewController: NSViewController {
  var folderPath : String = "";
  
  @IBOutlet weak var fileSystemTree: FileSystemTree!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    folderPath = "\(notification.object ?? "")"
    // TODO: Building the file system tree with folder path
    fileSystemTree.setRootFolder(folderPath: folderPath)
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
