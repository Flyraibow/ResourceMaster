//
//  ResourceManager.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Foundation

let kResourceManagerNotificationRootChanged = NSNotification.Name("kResourceManagerNotificationRootChanged");


class ResourceManager {
  static let sharedInstance = ResourceManager()
  
  private init() {
  }
  func checkingDefaultSettings() {
    // TODO: checking existing repository from config. If it's existed, then choose the folder
  }
  
  func chooseRootFolder(folder: String) {
    // TOTO:
    /*
     1. ✅ checking whether the folder exist
     2. checking whether the folder is empty
          1) if empty , init the folder and create related initiate files in the folder
          2) if not mepty, checking whether it contains correct readable resource config file
            a) if it passes the check then, load the resources
            b) ask user whether to clean the folder and initiate it
     3. complete the loading with correct folder
     */
    var isDic : ObjCBool = false;
    FileManager.default.fileExists(atPath: folder, isDirectory: &isDic);
    if (isDic.boolValue) {
      NotificationCenter.default.post(name: kResourceManagerNotificationRootChanged, object: folder)
    } else {
      let errorMsg = "\(folder) is not directory."
      MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: errorMsg)
    }
  }
}
