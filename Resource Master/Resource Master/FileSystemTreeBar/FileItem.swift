//
//  FeedItem.swift
//  Resource Master
//
//  Created by Marvin on 2/13/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

import Cocoa

class FileItem: NSObject {
    let name: String
    let path: String
    init(name: String, path: String) {
        self.name = name
        self.path = path
    }
    
    func shouldShow() -> Bool {
        return true
    }
    
    func filePathName() -> String {
        return "\(self.path)/\(self.name)"
    }
    
    func isFolder() -> Bool {
        let ext = URL(string: self.name )?.pathExtension
        return  ext == "" || ext == nil
    }
    
    func isImage() -> Bool {
        let exts = URL(string: self.name)?.pathExtension
        return exts == "png" || exts == "jpg" || exts == "jepg"
    }
    
    func image() -> NSImage {
        let image = NSImage(contentsOfFile: self.filePathName())
        return image!
    }
    
    func sizeWithUnit(kbValue: UInt64) -> String {
        var unitIdx = 0
        var val = kbValue
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while val > 1024 {
            val = val / 1024
            unitIdx += 1
        }
        return "\(val) \(tokens[unitIdx])"
    }
    
}

