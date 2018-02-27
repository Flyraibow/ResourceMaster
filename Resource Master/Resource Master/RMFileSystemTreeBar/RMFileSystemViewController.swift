//
//  LeftViewController.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class RMFileSystemViewController: NSViewController {
  var folderPath : String = "";
  var selectedFileUrl : String = ""
  static let sharedInstance = RMFileSystemViewController()
  @IBOutlet weak var outLineView: NSOutlineView!
  var files = [RMFileItem]()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .short
    let rootPath = UserDefaults.standard.object(forKey: "RMSRootPath")
    folderPath = rootPath == nil ? "" : rootPath as! String
    RMFileSystemViewController.sharedInstance.folderPath = folderPath
    files = RMFilePathManager.fileList(folderPath)
    self.outLineView.reloadData()
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reloadOutLineView(notification:)), name: kResourceManagerFileDeletedOrCreated, object: nil)
    
  }
    
    @objc func reloadOutLineView(notification: Notification) {
        files = RMFilePathManager.fileList(folderPath)
        self.outLineView.reloadData()
    }
  
  @objc func updateRootFolderPath(notification : Notification) {
    RMFileSystemViewController.sharedInstance.folderPath = "\(notification.object ?? "")"
    folderPath = "\(notification.object ?? "")"
    files = RMFilePathManager.fileList(folderPath)
    self.outLineView.reloadData()
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
        if let file = item as? RMFileItem {
            if file.isFolder() {
                return RMFilePathManager.fileList(file.filePathName()).count
            }
        }
        return files.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let file = item as? RMFileItem {
            return RMFilePathManager.fileList(file.filePathName())[index]
        }
        return files[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let file = item as? RMFileItem {
            return file.isFolder()
        }
        return false
    }
}

extension RMFileSystemViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let feedItem = item as? RMFileItem {
            if (tableColumn?.identifier.rawValue == "nameColumn") {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.name
                    textField.sizeToFit()
                }
                if let imageView = view?.imageView {
                    imageView.image = feedItem.fileIcon()
                    if feedItem.isImage() {
                        imageView.image = feedItem.image()
                    } else {
                        imageView.image = feedItem.fileIcon()
                    }
                }
            }
        }
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        let selectedIndex = outlineView.selectedRow
        if let feedItem = outlineView.item(atRow: selectedIndex) as? RMFileItem {
            RMFileSystemViewController.sharedInstance.selectedFileUrl = feedItem.filePathName()
        }
    }
}




