//
//  LeftViewController.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class RMFileSystemViewController: NSViewController {
  @IBOutlet weak var outLineView: NSOutlineView!
  @IBOutlet var menuBar: NSMenu!
  let dateFormatter = DateFormatter()
  var fileTree: RMFileTree?;
  var selectedFileTreeNode: RMFileTreeNode?;
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    dateFormatter.dateStyle = .short
//    let rootPath = UserDefaults.standard.object(forKey: DEFAULT_ROOT_PATH)
//    folderPath = rootPath == nil ? "" : rootPath as! String
//    RMFileSystemViewController.sharedInstance.folderPath = folderPath
//    files = RMFilePathManager.fileList(folderPath)
//    self.outLineView.reloadData()
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(removeSelectedFile(notification:)), name: kResourceManagerFileDeleted, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(reloadOutLineView(notification:)), name: kResourceManagerFileDeletedOrCreated, object: nil)
    
  }
  
  @objc func reloadOutLineView(notification: Notification) {
//    files = RMFilePathManager.fileList(folderPath)
//    self.outLineView.reloadData()
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    let rootPath = String(describing: notification.object!)
    do {
      fileTree = try RMFileTree.init(rootPath: rootPath);
      self.outLineView.reloadData();
    } catch {
      MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: "Path: " + rootPath + " is invalid " + error.localizedDescription);
    }
  }
  
  @objc func removeSelectedFile(notification : Notification) {
  }
  
  @IBAction func clickShowInFinder(_ sender: NSMenuItem) {
    
  }
  
  @IBAction func clickNewFile(_ sender: NSMenuItem) {
  }
  
  @IBAction func clickAddExistingFiles(_ sender: NSMenuItem) {
  }
  
  @IBAction func clickDeleting(_ sender: NSMenuItem) {
    let clickedRow = outLineView.item(atRow: outLineView.clickedRow) as? RMFileTreeNode;
    if clickedRow != nil {
      if clickedRow!.parent == nil {
        MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: "Unable to delte root folder");
        return;
      }
      if MessageBoxManager.sharedInstance.showYesNoBox(title: "Warning !!", message: "Are you sure to delete " + clickedRow!.fileName + " ?") {
        
      }
    }
  }
  
  @IBAction func clickNewGroup(_ sender: NSMenuItem) {
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}


extension RMFileSystemViewController: NSOutlineViewDataSource {
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if let fileTreeNode = item as? RMFileTreeNode {
      if fileTreeNode.isFolder && fileTreeNode.fileList != nil {
        return fileTreeNode.fileList!.count;
      } else {
        return 0;
      }
    }
    return fileTree != nil ? 1 : 0;
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if let fileTreeNode = item as? RMFileTreeNode {
      if fileTreeNode.isFolder && fileTreeNode.fileList != nil {
        return fileTreeNode.fileList![index];
      }
    }
    return fileTree!.virtualFileNode;
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    if let fileTreeNode = item as? RMFileTreeNode {
      return fileTreeNode.isFolder
    }
    return true;
  }
}

extension RMFileSystemViewController: NSOutlineViewDelegate {
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    if let fileTreeNode = item as? RMFileTreeNode {
      if (tableColumn?.identifier.rawValue == "nameColumn") {
        view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView
        if let textField = view?.textField {
          textField.stringValue = fileTreeNode.fileName
          if (FileManager.default.fileExists(atPath: fileTreeNode.path!)) {
            textField.textColor = NSColor.black;
          } else {
            textField.textColor = NSColor.red;
          }
          textField.sizeToFit()
        }
//        if let imageView = view?.imageView {
//          imageView.image = feedItem.fileIcon()
//          if feedItem.isImage() {
//            imageView.image = feedItem.image()
//          } else {
//            imageView.image = feedItem.fileIcon()
//          }
//        }
      }
    }
    return view
  }
  
  func outlineViewSelectionDidChange(_ notification: Notification) {
    guard let outlineView = notification.object as? NSOutlineView else {
      return
    }
    let selectedIndex = outlineView.selectedRow
    if let feedItem = outlineView.item(atRow: selectedIndex) as? RMFileTreeNode {
      selectedFileTreeNode = feedItem;
    } else {
      selectedFileTreeNode = nil;
    }
  }
}
