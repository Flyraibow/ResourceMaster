//
//  FileTreeNode.swift
//  Resource Master
//
//  Created by Yujie Liu on 2/27/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

import Foundation

let WORK_PATH = "work path";
let FILE_NAME = "name";
let FILE_TYPE = "type";
let FILE_LIST = "fileList";
let FILE_DESC = "desc";
let FILE_TAG = "tag";

class RMFileTreeNode: NSObject {
  var fileName: String?;
  var fileType: String?;
  var fileList: Array<RMFileTreeNode>?;
  var isFolder: Bool;
  var tagList: Array<String>?;
  var desc: String?
  var parent :RMFileTreeNode?;
  
  init(json: Any) {
    isFolder = false;
    super.init();
    isFolder = false;
    if let jsonObj = json as? Dictionary<String, Any> {
      fileName = jsonObj[FILE_NAME] as? String;
      fileType = jsonObj[FILE_TYPE] as? String;
      desc = jsonObj[FILE_DESC] as? String;
      if let fileListArray = jsonObj[FILE_LIST] as? Array<Any> {
        isFolder = true;
        fileList = Array<RMFileTreeNode>();
        for node in fileListArray {
          let node = RMFileTreeNode.init(json:node);
          node.parent = self;
          fileList!.append(node);
        }
      }
    }
  }
  func jsonObject() -> Dictionary<String, Any> {
    var dict = Dictionary<String, Any>();
    dict[FILE_NAME] = fileName;
    dict[FILE_TYPE] = fileType;
    dict[FILE_DESC] = desc;
    if fileList != nil {
      var arr = Array<Any>();
      for fileNode in fileList! {
        arr.append(fileNode.jsonObject())
      }
      dict[FILE_LIST] = arr;
    }
    
    return [String: String]();
  }
}

class RMFileTree: NSObject {
  var fileList: Array<RMFileTreeNode>?;
  var configPath: String?;
  init(json: Any) {
    if let jsonObj = json as? Dictionary<String, Any> {
      if configPath == nil {
        configPath = jsonObj[WORK_PATH] as? String;
      }
      if let fileListArray = jsonObj[FILE_LIST] as? Array<Any> {
        fileList = Array<RMFileTreeNode>();
        for node in fileListArray {
          fileList!.append(RMFileTreeNode.init(json:node));
        }
      }
    }
  }

  convenience init(jsonPath: String) {
    do {
      let data = try NSData.init(contentsOfFile: jsonPath) as Data;
      let jsonObj = try JSONSerialization.jsonObject(with: data, options: []);
      self.init(json: jsonObj);
      return;
    } catch {
      print(error.localizedDescription)
    }
    self.init(json: [String: String]())
    configPath = jsonPath;
  }
  
  func jsonObject() -> Any {
    var dict = Dictionary<String, Any>();
    dict[WORK_PATH] = configPath;
    
    if fileList != nil {
      var arr = Array<Any>();
      for fileNode in fileList! {
        arr.append(fileNode.jsonObject())
      }
      dict[FILE_LIST] = arr;
    }
    return dict;
  }

  func writeToDisk() {
    assert(configPath != nil, "The config path is nil");
    let tempConfigPath = NSTemporaryDirectory() + "/" + "temp.json";
    do {
      try FileManager.default.moveItem(atPath: configPath!, toPath: tempConfigPath)
      let data = try JSONSerialization.data(withJSONObject: jsonObject(), options: [])
      FileManager.default.createFile(atPath: configPath!, contents: data, attributes: nil)
    } catch {
      print(error.localizedDescription)
      if (!FileManager.default.fileExists(atPath: configPath!) && FileManager.default.fileExists(atPath: tempConfigPath)) {
        do {
          try FileManager.default.moveItem(atPath: tempConfigPath, toPath: configPath!)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    
  }
}

