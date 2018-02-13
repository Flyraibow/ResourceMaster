//
//  FeedItem.swift
//  Resource Master
//
//  Created by Marvin on 2/13/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class FileSystemItem: NSObject {
    var relativePath: String
    var parent: FileSystemItem?
    
    lazy var children: [FileSystemItem]? = {
        let fileManager = FileManager.default
        let fullPath = self.fullPath()
        var isDir = ObjCBool(false)
        let valid = fileManager.fileExists(atPath: fullPath as String, isDirectory: &isDir)
        var newChildren: [FileSystemItem] = []
        
        if (valid && isDir.boolValue) {
            let array: [AnyObject]?
            do {
                array = try fileManager.contentsOfDirectory(atPath: fullPath as String) as [AnyObject]
            } catch _ {
                array = nil
            }
            
            if let ar = array as? [String] {
                for contents in ar {
                    let newChild = FileSystemItem(path: contents as NSString, parent: self)
                    newChildren.append(newChild)
                }
            }
            return newChildren
        } else {
            return  nil
        }
    }()
    
    public override var description: String {
        return "FileSystemItem:\(relativePath)"
    }
    
    init(path: NSString, parent: FileSystemItem?) {
        self.relativePath = path.lastPathComponent.copy() as! String
        self.parent = parent
    }
    
    class var rootItem: FileSystemItem {
        get {
            return FileSystemItem(path:"/", parent: nil)
        }
    }
    
    public func numberOfChildren() -> Int {
        guard let children = self.children else { return 0 }
        return children.count
    }
    
    public func childAtIndex(n: Int) -> FileSystemItem? {
        guard let children = self.children else { return nil }
        return children[n]
    }
    
    public func fullPath() -> NSString {
        guard let parent = self.parent else { return relativePath as NSString }
        return parent.fullPath().appendingPathComponent(relativePath as String) as NSString
    }
}
