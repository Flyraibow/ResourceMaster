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
  var rootPath : String?
  
  private init() {
  }
    func checkingDefaultSettings(path: String) -> Bool {
    // TODO: checking existing repository from config. If it's existed, then choose the folder
        let ans = FilePathManager.validPath(path: path)
        if !ans {
            let errorMsg = "\(path) is not a RSM directory."
            MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: errorMsg)
        }
        return ans
  }
  
  func chooseRootWorkSpace() {
    rootPath = MessageBoxManager.sharedInstance.selectFolder()
    if (rootPath != nil) {
        ResourceManager.sharedInstance.rootPath = rootPath
      let folderPath = rootPath!
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
      FileManager.default.fileExists(atPath: folderPath, isDirectory: &isDic);
      var isValideRSMPath = self.checkingDefaultSettings(path: folderPath)
      if (isDic.boolValue && isValideRSMPath) {
        let defaults = UserDefaults.standard
        defaults.set(folderPath, forKey: "RMSRootPath")
        NotificationCenter.default.post(name: kResourceManagerNotificationRootChanged, object: folderPath)
      }
    }
  }
    
    
    
    func createNewWorkSpace() {
        rootPath = MessageBoxManager.sharedInstance.createFolder()
        if (rootPath != nil) {
            ResourceManager.sharedInstance.rootPath = rootPath
            let folderPath = rootPath!
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
            FileManager.default.fileExists(atPath: folderPath, isDirectory: &isDic);
            var isValideRSMPath = self.checkingDefaultSettings(path: folderPath)
            if (isDic.boolValue && isValideRSMPath) {
                let defaults = UserDefaults.standard
                defaults.set(folderPath, forKey: "RMSRootPath")
                NotificationCenter.default.post(name: kResourceManagerNotificationRootChanged, object: folderPath)
            }
        }
    }
}
