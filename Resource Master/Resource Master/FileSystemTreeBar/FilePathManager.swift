//
//  FileSystem.swift
//  Resource Master
//
//  Created by Marvin on 2/15/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

//
//  Feed.swift
//  Reader
//
//  Created by Jean-Pierre Distler on 19.01.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Cocoa

class FilePathManager: NSObject {
    let name: String
    class func fileList(_ fileName: String) -> [FileItem] {
        var files = [FileItem]()
        do {
            let fs = try FileManager.default.contentsOfDirectory(atPath: fileName)
            for name in fs {
                let tmpItem = FileItem(name: name, path: fileName)
                if tmpItem.shouldShow() {
                    files.append(tmpItem)
                }
            }
        } catch {            print(error)
        }
        return files
    }
    
    
    class func validPath(path: String) -> Bool {
        do {
            let fs = try FileManager.default.contentsOfDirectory(atPath: path)
            for name in fs {
                if name == "RMSConfig.json" {
                    return true
                }
            }
        } catch {
            print(error)
        }
        return false
    }
    
    init(name: String) {
        self.name = name
    }
}

