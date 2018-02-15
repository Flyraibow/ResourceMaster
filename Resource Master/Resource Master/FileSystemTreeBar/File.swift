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
    var children = [FileItem]()
    
    class func fileList(_ fileName: String) -> [FileItem] {
        //1
        var files = [FileItem]()
        
        
        let fd = FileManager.default
        fd.enumerator(atPath: fileName)?.forEach({ (e) in
            if let fileItem = e as? String, let url = URL(string: e as! String) {
                print(url.pathExtension)
                files.append(FileItem(name: fileItem))
//                let file = File(name: fileItem.object(forKey: "name") as! String)
//                //5
//                let items = fileItem.object(forKey: "items") as! [NSDictionary]
//                //6
//                for dict in items {
//                    //7
//                    let item = FileItem(dictionary: dict)
//                    file.children.append(item)
//                }
//                //8
//                files.append(file)
            }
        })
        //2
//        if let fileList = NSArray(contentsOfFile: fileName) as? [NSDictionary] {
//            //3
//            for fileItem in fileList {
//                //4
//
//            }
//        }
        
        //9
        return files
    }
    
    init(name: String) {
        self.name = name
    }
}

