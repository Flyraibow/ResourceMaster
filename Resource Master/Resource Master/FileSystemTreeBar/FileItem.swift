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
//    let url: String
    let name: String
//    let publishingDate: Date
    
//    init(dictionary: NSDictionary) {
////        self.url = dictionary.object(forKey: "url") as! String
//        self.name = dictionary.object(forKey: "name") as! String
////        self.publishingDate = dictionary.object(forKey: "date") as! Date
//    }
    init(name: String) {
        self.name = name
    }
    
    func isFolder() -> Bool {
        let ext = URL(string: self.name )?.pathExtension
        return  ext == "" || ext == nil
    }
    
    func isImage() -> Bool {
        let exts = URL(string: self.name)?.pathExtension
        return exts == "png" || exts == "jpg" || exts == "jepg"
    }
    
    func size() -> String {
        let filePath = ResourceManager.sharedInstance.rootPath! + "/\(self.name)"
        var fileSize : UInt64 = 0
        
        do {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        return String(fileSize) + " KB"
    }
    
    func kind() -> String {
        let ext = URL(string: self.name )?.pathExtension
        if ext == "" || ext == nil {
            return "Folder"
        } else {
            return ext!
        }
    }
    
    func image() -> NSImage {
        let filePath = ResourceManager.sharedInstance.rootPath! + "/\(self.name)"
        let image = NSImage(contentsOfFile: filePath)
        return image!
    }
    

}

