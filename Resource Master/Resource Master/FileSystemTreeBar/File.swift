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

class File: NSObject {
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
        } catch {
            print(error)
        }
        return files
    }
    init(name: String) {
        self.name = name
    }
}

