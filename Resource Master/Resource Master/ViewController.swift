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
  }
  @IBAction func clickImport(_ sender: NSButton) {
    // 点击导入按钮，选择一个文件夹
    let dialog = NSOpenPanel();
    dialog.title                   = "choose a folder";
    dialog.message                 = "choose an empty folder to initial resource tree, or choose an exising folder to load";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseDirectories    = true;
    dialog.canCreateDirectories    = true;
    dialog.allowsMultipleSelection = false;
    dialog.canChooseFiles          = false;
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      let result = dialog.url // Pathname of the file
      
      if (result != nil) {
        let path = result!.path
        if (path != labPath.stringValue) {
          labPath.stringValue = path
          // Updating repository
          ResourceManager.sharedInstance.chooseRootFolder(folder: path)
        }
      }
    } else {
      // User clicked on "Cancel"
      return
    }
  }
  
  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}

