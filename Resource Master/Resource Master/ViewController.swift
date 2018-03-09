//
//  ViewController.swift
//  TestSwift
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa


let kResourceManagerFileDeletedOrCreated = NSNotification.Name("kResourceManagerFileDeletedOrCreated");

class ViewController: NSViewController {
  
  @IBOutlet weak var labPath: NSTextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
//    var path = UserDefaults.standard.object(forKey: DEFAULT_ROOT_PATH)
//    path = path == nil ? "" : path
//    self.labPath.stringValue = path as! String
//    // handle those folder used to be a valide RMS workspace but not any more
//    if !RMResourceManager.sharedInstance.checkingDefaultSettings(path: path as! String, showError: false) {
//      UserDefaults.standard.removeObject(forKey: DEFAULT_ROOT_PATH)
//    }
//    
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    let folderPath = String(describing: notification.object!)
    labPath.stringValue = folderPath
  }
  
  
  @IBAction func didTapAdd(_ sender: Any) {
    // TODO: MOVE LOGIC TO MANAGER
//    var targetUrl = RMFileSystemViewController.sharedInstance.selectedFileUrl
//    if targetUrl == "" {
//      targetUrl = RMFileSystemViewController.sharedInstance.folderPath
//    }
//    if targetUrl != "" {
//      let pickUrl = MessageBoxManager.sharedInstance.selectFiles()
//      let fileManager = FileManager.default
//      if pickUrl != nil {
//        let fileName = URL(fileURLWithPath: pickUrl!).lastPathComponent
//        do {
//          try fileManager.copyItem(atPath: pickUrl!, toPath: "\(targetUrl)/\(fileName)")
//          NotificationCenter.default.post(name: kResourceManagerFileDeletedOrCreated, object: nil)
//        }
//        catch let error as NSError {
//          print("Ooops! Something went wrong: \(error)")
//        }
//      }
//    }
  }
  
  @IBAction func didTapDelete(_ sender: Any) {
    // TODO: Move logic to manager
//    let targetUrl = RMFileSystemViewController.sharedInstance.selectedFileUrl
//    if (targetUrl != "") {
//      let fileManager = FileManager.default
//      do {
//        try fileManager.trashItem(at: URL(fileURLWithPath: targetUrl), resultingItemURL: nil)
//        NotificationCenter.default.post(name: kResourceManagerFileDeletedOrCreated, object: nil)
//        RMFileSystemViewController.sharedInstance.selectedFileUrl = ""
//      }
//      catch let error as NSError {
//        print("Ooops! Something went wrong: \(error)")
//      }
//    }
  }
  
  @IBAction func clickRefresherButton(_ sender: Any) {
    if (RMResourceManager.sharedInstance.rootPath == nil) {
      RMResourceManager.sharedInstance.chooseRootWorkSpace()
    } else {
      // TODO: Referesh the selected root folder
    }
  }
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self);
  }
}

