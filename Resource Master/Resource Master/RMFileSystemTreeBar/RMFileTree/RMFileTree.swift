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

let FILE_TYPE_FOLDER = "folder";
let FILE_TYPE_UNKNOWN = "unknown";

let kRMSConfigFileName = "RMSConfig.json";

enum RMFileTreeNodeError: Error {
  case wrongJsonFileFormat
  case WrongConfigPath
}

class RMFileTreeNode: NSObject {
  var isRoot: Bool;
  var fileName: String;
  var fileType: String?;
  var fileList: Array<RMFileTreeNode>?;
  var isFolder: Bool;
  var tagList: Array<String>?;
  var desc: String?
  var parent :RMFileTreeNode?;
  var path: String?
  
  init(json: Any, parentPath: String, isRoot : Bool = false) {
    isFolder = false;
    fileName = "undefined";
    self.isRoot = isRoot;
    super.init();
    isFolder = false;
    if let jsonObj = json as? Dictionary<String, Any> {
      if let name = jsonObj[FILE_NAME] {
        fileName = name as! String;
      }
      fileType = jsonObj[FILE_TYPE] as? String;
      if !isRoot {
        path = (parentPath as NSString).appendingPathComponent(fileName);
      } else {
        path = parentPath;
      }
      desc = jsonObj[FILE_DESC] as? String;
      isFolder = (jsonObj[FILE_TYPE] as? String) == FILE_TYPE_FOLDER;
      if let fileListArray = jsonObj[FILE_LIST] as? Array<Any> {
        isFolder = true;
        fileList = Array<RMFileTreeNode>();
        for node in fileListArray {
          let fileNode = RMFileTreeNode.init(json: node, parentPath: path!)
          fileNode.parent = self;
          fileList!.append(fileNode);
        }
        assert(verifyFileNames(), "file duplication verify failed");
      }
    }
  }
  
  init(fileName: String, parentNode:RMFileTreeNode?, actualPath: String? = nil, desc: String? = nil, tags:Array<String>? = nil, isRoot: Bool = false) {
    isFolder = true;
    self.fileName = fileName;
    self.isRoot = isRoot;
    super.init()
    self.parent = parentNode;
    self.desc = desc;
    self.tagList = tags;
    if parentNode != nil {
      assert(parentNode!.appendNode(fileNode: self))
      // verify there are no duplicators in the same folder
      assert(parentNode!.verifyFileNames(), "file duplication verify failed");
    }
    if actualPath != nil {
      var isDic : ObjCBool = false;
      assert (FileManager.default.fileExists(atPath: actualPath!, isDirectory: &isDic), "non existing files are added!");
      self.isFolder = isDic.boolValue;
      let workPath = self.getFileTree()?.workPath;
      assert(workPath != nil, "not able to copy a file to non existing work place")
      if actualPath!.hasPrefix(workPath!) {
        // TODO: file already exist in the file system
      } else {
        // TODO: file is not in the file system, make a copy
      }
    }
    
    self.fileType = isFolder ? FILE_TYPE_FOLDER : FILE_TYPE_UNKNOWN;
  }
  
  func appendNode(fileNode: RMFileTreeNode) -> Bool {
    if self.isFolder {
      if (fileList == nil) {
        fileList = Array<RMFileTreeNode>()
      }
      self.fileList!.append(fileNode)
      fileNode.parent = self;
      fileNode.path = (self.path! as NSString).appendingPathComponent(fileNode.fileName);
      return true;
    }
    return false;
  }
  
  func verifyFileNames() -> Bool {
    var fileNameSet = Set<String>()
    if self.fileList != nil {
      for fileNode in self.fileList! {
        if fileNameSet.contains(fileNode.fileName) {
          return false;
        }
        fileNameSet.insert(fileNode.fileName);
      }
    }
    return true;
  }
  
  func validateCurrentFolderIfNeeded() -> Bool {
    var flag = true;
    if (self.isFolder) {
      if fileList != nil {
        for fileNode in fileList! {
          flag = fileNode.validateCurrentFolderIfNeeded() && flag;
        }
      }
      if (self.path != nil) {
        var isDic : ObjCBool = false;
        if (!FileManager.default.fileExists(atPath: self.path!, isDirectory: &isDic) || isDic.boolValue == false) {
          do {
            try FileManager.default.createDirectory(atPath: self.path!, withIntermediateDirectories: true, attributes: nil);
          } catch {
            print(error.localizedDescription)
            return false;
          }
        }
      }
    }
    return flag;
  }
  
  
  var _fileTree: RMFileTree?
  func getFileTree() -> RMFileTree? {
    if _fileTree != nil {
      return _fileTree;
    } else if (parent != nil) {
      self._fileTree = parent!.getFileTree();
      return self._fileTree;
    }
    return nil;
  }
  
  func setFileTree(fileTree: RMFileTree) {
    _fileTree = fileTree;
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
    
    return dict;
  }
  
  // Node operation
  func deleteChildNode(childNode : RMFileTreeNode) -> Bool {
    if fileList != nil && fileList!.contains(childNode) {
      if !FileManager.default.fileExists(atPath: childNode.path!) {
        // Remove reference
        if let index = childNode.parent!.fileList?.index(of: childNode) {
          childNode.parent!.fileList?.remove(at: index);
        }
      } else {
        let result = MessageBoxManager.sharedInstance.show3ButtonBox(title: "Warning !!", message: "Are you sure to delete " + childNode.fileName + " ?", button1: "Cancel", button2: "Remove Reference", button3: "Move to trash")
        if result > 0 {
          // Remove reference
          if let index = childNode.parent!.fileList?.index(of: childNode) {
            childNode.parent!.fileList?.remove(at: index);
          }
          if result == 2 {
            // move to trash
            do {
              try FileManager.default.removeItem(atPath: childNode.path!);
            } catch {
              MessageBoxManager.sharedInstance.showErrorMessage(errorMsg: "Unable to delte: " + childNode.path! + error.localizedDescription);
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  func fileExistByRelativeComponents(components: Array<String>) -> Bool {
    var leftOver = components
    for fileName in components {
      leftOver.removeFirst();
      if fileName.count > 0 {
        if fileList != nil {
          for fileNode in fileList! {
            if fileNode.fileName == fileName {
              if leftOver.isEmpty {
                return true;
              } else {
                return fileNode.fileExistByRelativeComponents(components:leftOver);
              }
            }
          }
        }
        break;
      }
    }
    return false;
  }
  
  func searchFileNodeByRelativeComponent(components: Array<String>) -> RMFileTreeNode? {
    var leftOver = components
    for fileName in components {
      leftOver.removeFirst();
      if fileName.count > 0 {
        if fileList != nil {
          for fileNode in fileList! {
            if fileNode.fileName == fileName {
              if leftOver.isEmpty {
                return fileNode;
              } else {
                return fileNode.searchFileNodeByRelativeComponent(components:leftOver);
              }
            }
          }
        }
        break;
      }
    }
    return nil;
  }
}

class RMFileTree: NSObject {
  var workPath: String?
  var configPath: String?;
  var virtualFileNode: RMFileTreeNode;
  init(json: Any) throws {
    if let jsonObj = json as? Dictionary<String, Any> {
      workPath = jsonObj[WORK_PATH] as? String;
      virtualFileNode = RMFileTreeNode.init(json: json, parentPath: workPath!, isRoot: true);
      virtualFileNode.isFolder = true;
      virtualFileNode.fileName = "Work Space";
      super.init();
      virtualFileNode.setFileTree(fileTree: self);
      if configPath == nil && workPath != nil {
        configPath = (workPath! as NSString).appendingPathComponent(kRMSConfigFileName);
      }
    } else {
      throw RMFileTreeNodeError.wrongJsonFileFormat
    }
  }

  convenience init(confPath: String) throws {
    do {
      let data = try NSData.init(contentsOfFile: confPath) as Data;
      let jsonObj = try JSONSerialization.jsonObject(with: data, options: []);
      try self.init(json: jsonObj);
      return;
    } catch {
      print(error.localizedDescription)
    }
    throw RMFileTreeNodeError.WrongConfigPath
  }
  
  convenience init(rootPath: String) throws {
    let configPath = (rootPath as NSString).appendingPathComponent(kRMSConfigFileName);
    try self.init(confPath: configPath);
  }
  
  func jsonObject() -> Any {
    var dict = Dictionary<String, Any>();
    dict[WORK_PATH] = virtualFileNode.path;
    
    if virtualFileNode.fileList != nil {
      var arr = Array<Any>();
      for fileNode in virtualFileNode.fileList! {
        arr.append(fileNode.jsonObject())
      }
      dict[FILE_LIST] = arr;
    }
    return dict;
  }

  func writeConfigToDisk() -> Bool {
    assert(configPath != nil, "The config path is nil");
    let tempConfigPath = (NSTemporaryDirectory() as NSString).appendingPathComponent("temp.json");
    do {
      if FileManager.default.fileExists(atPath: configPath!) {
        // Keep original one in case the same step fails
        try FileManager.default.moveItem(atPath: configPath!, toPath: tempConfigPath)
      }
      let data = try JSONSerialization.data(withJSONObject: jsonObject(), options: [])
      FileManager.default.createFile(atPath: configPath!, contents: data, attributes: nil)
      if FileManager.default.fileExists(atPath: tempConfigPath) {
        // remove temp one
        try FileManager.default.removeItem(atPath: tempConfigPath);
      }
      return true;
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
    return false;
  }
  
  func createFileDirectories() -> Bool {
    if !self.writeConfigToDisk() {
      return false;
    }
    return self.virtualFileNode.validateCurrentFolderIfNeeded();
  }
  
  func fileExistByPath(path: String) -> Bool {
    if workPath != nil {
      if path.starts(with: workPath!) {
        let relativePathCount = path.count - workPath!.count;
        let relativePath = path.suffix(relativePathCount);
        let components = relativePath.components(separatedBy: "/");
        return virtualFileNode.fileExistByRelativeComponents(components: components);
      }
    }
    return false;
  }
  
  func searchFileNodeByPath(path: String) -> RMFileTreeNode? {
    if workPath != nil {
      if path.starts(with: workPath!) {
        let relativePathCount = path.count - workPath!.count;
        let relativePath = path.suffix(relativePathCount);
        let components = relativePath.components(separatedBy: "/");
        return virtualFileNode.searchFileNodeByRelativeComponent(components: components);
      }
    }
    return nil;
  }
}

