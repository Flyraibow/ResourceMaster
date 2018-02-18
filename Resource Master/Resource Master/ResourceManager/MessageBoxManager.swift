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
  
    
    func createFolder() -> String? {
        return self.showFolderSelectPanel(title: "Create a workspace for Resource Master", message: "Create a new folder as your workspace", sizeIndicator: true, showHidden: false, canChooseDirs: false, canCreateDirs: true, allowMutiSelec: false, canChooseFiles: false)
    }
    
    func selectFiles() -> String? {
        return self.showFolderSelectPanel(title: "Choose files", message: "Choose files you want to import", sizeIndicator: true, showHidden: false, canChooseDirs: false, canCreateDirs: true, allowMutiSelec: false, canChooseFiles: true)
    }
    
    func selectFolder() -> String? {
        return self.showFolderSelectPanel(title: "Choose a folder", message: "Choose an empty folder to initial resource tree, or choose an existing folder to load", sizeIndicator: true, showHidden: false, canChooseDirs: true, canCreateDirs: true, allowMutiSelec: false, canChooseFiles: false)
    }
    
    func showFolderSelectPanel(title: String, message: String, sizeIndicator: Bool, showHidden: Bool, canChooseDirs: Bool, canCreateDirs: Bool, allowMutiSelec: Bool, canChooseFiles: Bool) -> String? {
    // 点击导入按钮，选择一个文件夹
    let dialog = NSOpenPanel();
    dialog.title                   =  title;
    dialog.message                 = message;
    dialog.showsResizeIndicator    = sizeIndicator;
    dialog.showsHiddenFiles        = showHidden;
    dialog.canChooseDirectories    = canChooseDirs;
    dialog.canCreateDirectories    = canCreateDirs;
    dialog.allowsMultipleSelection = allowMutiSelec;
    dialog.canChooseFiles          = canChooseFiles;
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      let result = dialog.url // Pathname of the file
      if (result != nil) {
        return result!.path
      }
    }
    return nil
  }
}


