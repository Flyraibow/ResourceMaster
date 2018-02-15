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
        return URL(string: self.name )!.pathExtension != ""
    }
}

