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
//    var children = [FileItem]()
    
    class func fileList(_ fileName: String) -> [FileItem] {
        var files = [FileItem]()
        do {
            let fs = try FileManager.default.contentsOfDirectory(atPath: fileName)
            for fileName in fs {
                let tmpItem = FileItem(name: fileName)
                if (tmpItem.isImage() || tmpItem.isFolder()) {
                    files.append(tmpItem)
                }
            }
        } catch {
            print(error)
        }
        return files
//        var files = [FileItem]()
//        let fd = FileManager.default
//        fd.enumerator(atPath: fileName)?.forEach({ (e) in
//            if let fileItem = e as? String, let url = URL(string: e as! String) {
//                print(fileItem)
//                let tmpItem = FileItem(name: fileItem)
//                if (tmpItem.isImage() || tmpItem.isFolder()) {
//                    files.append(tmpItem)
//                }
//            }
//        })
//        return files
    }
    
    init(name: String) {
        self.name = name
    }
}

