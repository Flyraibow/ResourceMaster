//
//  FeedItem.swift
//  Resource Master
//
//  Created by Marvin on 2/13/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

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
        let ext = URL(string: self.name)?.pathExtension
        return  ext == "" || ext == nil
    }
    
    func isAudio() -> Bool {
        
        let exts = URL(string: self.name)?.pathExtension
        return exts == "mp3" || exts == "mp4"
    }
    
    func isTxt() -> Bool {
        let exts = URL(string: self.name)?.pathExtension
        return exts == "txt"
    }
    
    func isImage() -> Bool {
        let exts = URL(string: self.name)?.pathExtension
        return exts == "png" || exts == "jpg" || exts == "jepg"
    }
    
    func image() -> NSImage {
        let image = NSImage(contentsOfFile: self.filePathName())
        return image!
    }
    
    func fileIcon() -> NSImage {
        let size = 64;
        let image = NSWorkspace.shared.icon(forFile: self.filePathName())
        image.size = NSMakeSize(CGFloat(size), CGFloat(size))
        return image
    }
}

