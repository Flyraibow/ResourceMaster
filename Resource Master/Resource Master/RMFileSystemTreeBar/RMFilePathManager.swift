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

let kRMSConfigFileName : String = "RMSConfig.json";

class RMFilePathManager: NSObject {
  let name: String
  class func fileList(_ fileName: String) -> [RMFileItem] {
    var files = [RMFileItem]()
    do {
      let fs = try FileManager.default.contentsOfDirectory(atPath: fileName)
      for name in fs {
        let tmpItem = RMFileItem(name: name, path: fileName)
        if tmpItem.shouldShow() {
          files.append(tmpItem)
        }
      }
    } catch {
      print(error)
    }
    return files
  }
  
  class func InitializeWorkplace(path: String) -> Bool {
    var isDic : ObjCBool = false;
    assert(FileManager.default.fileExists(atPath: path, isDirectory: &isDic) && isDic.boolValue, "Invalid workplace path");
    let jsonFilePath = (path as NSString).appendingPathComponent(kRMSConfigFileName);
    assert(FileManager.default.fileExists(atPath: jsonFilePath) == false, "workplace already exist");
    let defaultFileTree = createDefaultRMFileTree(path: path)!;
    return defaultFileTree.createFileDirectories();
  }
  
  
  class func validPath(path: String) -> Bool {
    let configPath = (path as NSString).appendingPathComponent(kRMSConfigFileName);
    return FileManager.default.fileExists(atPath: configPath);
  }
  
  init(name: String) {
    self.name = name
  }
}

