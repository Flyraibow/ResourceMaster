//
//  RMFileTreeDefault.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/28/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Foundation

func initializeWorkplace(path: String) -> Bool {
  var isDic : ObjCBool = false;
  assert(FileManager.default.fileExists(atPath: path, isDirectory: &isDic) && isDic.boolValue, "Invalid workplace path");
  let jsonFilePath = (path as NSString).appendingPathComponent(kRMSConfigFileName);
  assert(FileManager.default.fileExists(atPath: jsonFilePath) == false, "workplace already exist");
  let defaultFileTree = createDefaultRMFileTree(path: path)!;
  return defaultFileTree.createFileDirectories();
}

func createDefaultRMFileTree(path: String) -> RMFileTree? {
  var dict = Dictionary<String, Any>();
  dict[WORK_PATH] = path;
  
  do {
    let defaultTree = try RMFileTree.init(json: dict);
    let _ = RMFileTreeNode.init(fileName: "Graphics", parentNode: defaultTree.virtualFileNode);
    let _ = RMFileTreeNode.init(fileName: "Sounds", parentNode: defaultTree.virtualFileNode);
    return defaultTree;
  } catch {
    print(error.localizedDescription)
  }
  return nil;
}
