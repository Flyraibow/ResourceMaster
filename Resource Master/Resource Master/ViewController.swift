//
//  ViewController.swift
//  TestSwift
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa


let kResourceManagerFileDeleted = NSNotification.Name("kResourceManagerFileDeleted");

class ViewController: NSViewController {
  
  @IBOutlet weak var labPath: NSTextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    let folderPath = String(describing: notification.object!)
    labPath.stringValue = folderPath
  }
  
  override func viewDidAppear() {
    let path = UserDefaults.standard.object(forKey: DEFAULT_ROOT_PATH);
    if path != nil {
      let folderPath = "\(path!)";
      RMResourceManager.sharedInstance.gotoVerifiedWorkSpace(rootPath: folderPath);
    }
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
    NotificationCenter.default.post(name: kResourceManagerFileDeleted, object: nil)
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

