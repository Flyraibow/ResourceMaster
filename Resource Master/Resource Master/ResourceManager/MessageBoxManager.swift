//
//  MessageBoxManager.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/11/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class MessageBoxManager {
  static let sharedInstance = MessageBoxManager()
  
  func showErrorMessage(title: String = "Error", errorMsg: String) {
    let alert: NSAlert = NSAlert()
    alert.messageText = title
    alert.informativeText = errorMsg
    alert.alertStyle = NSAlert.Style.warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
  }
  
  func showYesNoBox(title: String = "", message: String) -> Bool {
    let alert: NSAlert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    alert.alertStyle = NSAlert.Style.informational
    alert.addButton(withTitle: "Yes")
    alert.addButton(withTitle: "No")
    return alert.runModal() == .alertFirstButtonReturn
  }
  
    
    func showFolderToAdd() -> String? {
        // 点击导入按钮，选择一个文件夹
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose files";
        dialog.message                 = "Choose files you want to import";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles          = true;
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                return result!.path
            }
        }
        return nil
    }

  func showFolderSelectPanel() -> String? {
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
        return result!.path
      }
    }
    return nil
  }
}
