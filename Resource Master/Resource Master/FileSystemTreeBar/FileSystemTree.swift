//
//  FileSystemTree.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/8/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Cocoa

class FileTreeStruct: NSObject {
  let children : NSMutableArray
  let fileName : String
  let isDirectory : Bool
  init(filePath : String) {
    var isDir : ObjCBool = false
    let fileManager = FileManager.default
    children = NSMutableArray()
    fileManager.fileExists(atPath: filePath, isDirectory: &isDir)
    isDirectory = isDir.boolValue
    fileName = (filePath as NSString).lastPathComponent
    if (isDir.boolValue) {
      do {
        let fileURLs = try fileManager.contentsOfDirectory(atPath: filePath)
        // TODO: Construct tree structure
        // TODO: Adding ignore file type in the future, ignore such as .DS_Store etc.
        print(fileURLs)
      } catch {
        print("Error while enumerating files ")
      }
    }
  }
}

class FileSystemTree : NSScrollView {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setRootFolder(folderPath: String) {
    let structure : FileTreeStruct = FileTreeStruct(filePath: folderPath)
  }
}
