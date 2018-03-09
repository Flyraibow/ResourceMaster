//
//  ResourceManager.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Foundation

let kResourceManagerNotificationRootChanged = NSNotification.Name("kResourceManagerNotificationRootChanged");

let DEFAULT_ROOT_PATH = "DEFAULT_ROOT_PATH";


class RMResourceManager {
  static let sharedInstance = RMResourceManager()
  var rootPath : String?
  
  private init() {
  }

  func chooseRootWorkSpace() {
    rootPath = MessageBoxManager.sharedInstance.selectFolder()
    if (rootPath != nil) {
      self.gotoVerifiedWorkSpace(rootPath: rootPath!);
    }
  }
  
  func createNewWorkSpace() {
    let workplaceDic :String = MessageBoxManager.sharedInstance.createWorkplace()
    if (workplaceDic.count > 0) {
      let workplaceDicPath = MessageBoxManager.sharedInstance.showFolderSelectPanel(title: "Choose the path of workplace", message: "Choose a folder to initialize your workplace", sizeIndicator: true, showHidden: false, canChooseDirs: true, canCreateDirs: true, allowMutiSelec: false, canChooseFiles: false)
      let workplacePath = (workplaceDicPath! as NSString).appendingPathComponent(workplaceDic);
      // Initialize workplace path
      do {
        try FileManager.default.createDirectory(atPath: workplacePath, withIntermediateDirectories: false, attributes: nil);
        if (initializeWorkplace(path: workplacePath)) {
          // Create work space successfully
          self.gotoVerifiedWorkSpace(rootPath: workplacePath);
        }
      } catch let error as NSError {
        MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: error.localizedDescription)
      }
    }
  }
  
  func gotoVerifiedWorkSpace(rootPath: String) {
    RMResourceManager.sharedInstance.rootPath = rootPath
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
    FileManager.default.fileExists(atPath: rootPath, isDirectory: &isDic);
    
    let configPath = (rootPath as NSString).appendingPathComponent(kRMSConfigFileName);
    let isValideRSMPath = FileManager.default.fileExists(atPath: configPath)
    if (isDic.boolValue && isValideRSMPath) {
      UserDefaults.standard.set(rootPath, forKey: DEFAULT_ROOT_PATH)
      NotificationCenter.default.post(name: kResourceManagerNotificationRootChanged, object: rootPath)
    }
  }
}

