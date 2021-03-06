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
  
  func show3ButtonBox(title: String = "", message: String, button1: String, button2: String, button3: String) -> NSInteger {
    let alert: NSAlert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    alert.alertStyle = NSAlert.Style.informational
    alert.addButton(withTitle: button1)
    alert.addButton(withTitle: button2)
    alert.addButton(withTitle: button3)
    let result = alert.runModal();
    if (result == .alertFirstButtonReturn) {
      return 0;
    } else if (result == .alertSecondButtonReturn) {
      return 1;
    } else if (result == .alertThirdButtonReturn) {
      return 2;
    }
    return 0;
  }
  
  
  func createWorkplace() -> String {
    let msg = NSAlert()
    msg.addButton(withTitle: "OK")      // 1st button
    msg.addButton(withTitle: "Cancel")  // 2nd button
    msg.messageText = "Create a workspace for Resource Master"
    msg.informativeText = "Create a new folder as your workspace"
    
    let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
    txt.stringValue = "My Workplace"
    
    msg.accessoryView = txt
    let response: NSApplication.ModalResponse = msg.runModal()
    
    if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
      return txt.stringValue
    } else {
      return ""
    }
  }
  
  func selectFiles() -> String? {
    return self.showFileSelectionPanel(title: "Choose files", message: "Choose files you want to import", sizeIndicator: true, showHidden: false, canChooseDirs: false, canCreateDirs: true, canChooseFiles: true)
  }
  
  func selectFolder() -> String? {
    return self.showFileSelectionPanel(title: "Choose a folder", message: "Choose an empty folder to initial resource tree, or choose an existing folder to load", sizeIndicator: true, showHidden: false, canChooseDirs: true, canCreateDirs: true, canChooseFiles: false)
  }
  
  func showFileSelectionPanel(title: String, message: String, sizeIndicator: Bool, showHidden: Bool, canChooseDirs: Bool, canCreateDirs: Bool, canChooseFiles: Bool) -> String? {
    let dialog = NSOpenPanel();
    dialog.title                   =  title;
    dialog.message                 = message;
    dialog.showsResizeIndicator    = sizeIndicator;
    dialog.showsHiddenFiles        = showHidden;
    dialog.canChooseDirectories    = canChooseDirs;
    dialog.canCreateDirectories    = canCreateDirs;
    dialog.canChooseFiles          = canChooseFiles;
    dialog.allowsMultipleSelection = false;
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      let result = dialog.url // Pathname of the file
      if (result != nil) {
        return result!.path
      }
    }
    return nil
  }
  
  func showFilesSelectionPanel(title: String, message: String, sizeIndicator: Bool, showHidden: Bool, canChooseDirs: Bool, canCreateDirs: Bool, canChooseFiles: Bool) -> Array<String>? {
    let dialog = NSOpenPanel();
    dialog.title                   =  title;
    dialog.message                 = message;
    dialog.showsResizeIndicator    = sizeIndicator;
    dialog.showsHiddenFiles        = showHidden;
    dialog.canChooseDirectories    = canChooseDirs;
    dialog.canCreateDirectories    = canCreateDirs;
    dialog.canChooseFiles          = canChooseFiles;
    dialog.allowsMultipleSelection = true;
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      var paths = Array<String>();
      for url in dialog.urls {
        paths.append(url.path);
      }
      return paths;
    }
    return nil
  }
}


