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
}
