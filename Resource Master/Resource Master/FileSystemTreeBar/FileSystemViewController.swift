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
  
  @IBOutlet weak var outLineView: NSOutlineView!
  var files = [FileItem]()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .short
    
    files = File.fileList(folderPath)
    NotificationCenter.default.addObserver(self, selector: #selector(updateRootFolderPath(notification:)), name: kResourceManagerNotificationRootChanged, object: nil)
  }
  
  @objc func updateRootFolderPath(notification : Notification) {
    folderPath = "\(notification.object ?? "")"
    files = File.fileList(folderPath)
    self.outLineView.reloadData()
//    self.outLineView.reloadItem(nil)
    // TODO: Building the file system tree with folder path
//    fileSystemTree.setRootFolder(folderPath: folderPath)
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
        //1
        if let file = item as? FileItem {
            if file.isFolder() {
                return File.fileList(file.name).count
            }
        }
        //2
        return files.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let file = item as? File {
            return File.fileList(file.name)[index]
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
        //1
        if let file = item as? File {
            if (tableColumn?.identifier)!.rawValue == "timeColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "timeCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = file.name
                    textField.sizeToFit()
                }
            }
        }
        else if let feedItem = item as? FileItem {
            //1
            if (tableColumn?.identifier)!.rawValue == "kindColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "kindCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    //3
                    //                    textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
                    textField.stringValue = feedItem.kind()
                    textField.sizeToFit()
                }
            } else if (tableColumn?.identifier)!.rawValue == "sizeColumn" {
                //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "sizeCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    //3
//                    textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
                    textField.stringValue = feedItem.size()
                    textField.sizeToFit()
                }
            } else {
                //4
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    //5
                    textField.stringValue = feedItem.name
                    textField.sizeToFit()
                }
                if let imageView = view?.imageView {
                    if feedItem.isImage() {
                        imageView.image = feedItem.image()
                    }
                }

            }
        }
        //More code here
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        //1
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        //2
        let selectedIndex = outlineView.selectedRow
        
        if let feedItem = outlineView.item(atRow: selectedIndex) as? FileItem {
            //3
//            let url = URL(string: feedItem.url)
//            //4
//            if let url = url {
//                //5
////                self.webView.mainFrame.load(URLRequest(url: url))
//            }
        }
    }
}




