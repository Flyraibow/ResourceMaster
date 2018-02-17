//
//  LeftViewController.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class FileSystemViewController: NSViewController {
  var folderPath : String = "";
  var selectedFileUrl : String = ""
  static let sharedInstance = FileSystemViewController()
  @IBOutlet weak var outLineView: NSOutlineView!
  var files = [FileItem]()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .short
    
    files = File.fileList(folderPath)
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reloadOutLineView(notification:)), name: kResourceManagerFileDeletedOrCreated, object: nil)
    
  }
    
    @objc func reloadOutLineView(notification: Notification) {
        files = File.fileList(folderPath)
        self.outLineView.reloadData()
    }
  
  @objc func updateRootFolderPath(notification : Notification) {
    FileSystemViewController.sharedInstance.folderPath = "\(notification.object ?? "")"
    folderPath = "\(notification.object ?? "")"
    files = File.fileList(folderPath)
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


extension FileSystemViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let file = item as? FileItem {
            if file.isFolder() {
                return File.fileList(file.filePathName()).count
            }
        }
        return files.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let file = item as? FileItem {
            return File.fileList(file.filePathName())[index]
        }
        return files[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let file = item as? FileItem {
            return file.isFolder()
        }
        return false
    }
}

extension FileSystemViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let feedItem = item as? FileItem {
            if (tableColumn?.identifier)!.rawValue == "kindColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "kindCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.kind()
                    textField.sizeToFit()
                }
            } else if (tableColumn?.identifier)!.rawValue == "sizeColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "sizeCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.size()
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.name
                    textField.sizeToFit()
                }
                if let imageView = view?.imageView {
                    if feedItem.isImage() {
                        imageView.image = feedItem.image()
                    } else {
                        imageView.image = NSImage(named:NSImage.Name(rawValue: "NSFolder"))
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
        if let feedItem = outlineView.item(atRow: selectedIndex) as? FileItem {
            FileSystemViewController.sharedInstance.selectedFileUrl = feedItem.filePathName()
        }
    }
}




