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
    ResourceManager.sharedInstance.checkingDefaultSettings();
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    let folderPath = String(describing: notification.object!)
    labPath.stringValue = folderPath
  }
  
    
    @IBAction func didTapAdd(_ sender: Any) {
        var targetUrl = FileSystemViewController.sharedInstance.selectedFileUrl
        if targetUrl == "" {
            targetUrl = FileSystemViewController.sharedInstance.folderPath
        }
        if targetUrl != "" {
            let pickUrl = MessageBoxManager.sharedInstance.showFolderToAdd()
            let fileManager = FileManager.default
            let fileName = URL(fileURLWithPath: pickUrl!).lastPathComponent
            do {
                try fileManager.copyItem(atPath: pickUrl!, toPath: "\(targetUrl)/\(fileName)")
                NotificationCenter.default.post(name: kResourceManagerFileDeletedOrCreated, object: nil)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        let targetUrl = FileSystemViewController.sharedInstance.selectedFileUrl
        if (targetUrl != "") {
            let fileManager = FileManager.default
            do {
                try fileManager.trashItem(at: URL(fileURLWithPath: targetUrl), resultingItemURL: nil)
                NotificationCenter.default.post(name: kResourceManagerFileDeletedOrCreated, object: nil)
                FileSystemViewController.sharedInstance.selectedFileUrl = ""
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
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

