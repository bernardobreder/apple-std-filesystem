//
//  StdFolder.swift
//  codegenv
//
//  Created by Bernardo Breder on 13/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import Optional
    import FileSystem
#endif

open class StdFolder: StdResource, Folder {
    
    func list(path: String, hasFile: Bool, hasFolder: Bool) throws -> [NativeResource] {
        return try NativeFileSystem.list(path: path, hasFile: hasFile, hasFolder: hasFolder)
    }
    
    func map(native: NativeResource) -> Resource {
        switch native.type {
        case .File: return StdFile(parent: self, name: native.name)
        case .Folder: return StdFolder(parent: self, name: native.name)
        case .Symbol: return StdFile(parent: self, name: native.name)
        }
    }
    
    public func list() throws -> [Resource] {
        return try list(path: path, hasFile: true, hasFolder: true).map(self.map(native:))
    }
    
    public func listFiles() throws -> [File] {
        return try list(path: path, hasFile: true, hasFolder: false).map { r in StdFile(parent: self, name: r.name) }
    }
    
    public func listFolders() throws -> [Folder] {
        return try list(path: path, hasFile: false, hasFolder: true).map { r in StdFolder(parent: self, name: r.name) }
    }
    
    public func find(_ name: String) throws -> Resource? {
        return try list(path: path, hasFile: true, hasFolder: true).filter {$0.name == name}.map(self.map(native:)).first
    }
    
    public func findFile(_ name: String) throws -> File? {
        return try list(path: path, hasFile: true, hasFolder: false).filter {$0.name == name}.map { r in StdFile(parent: self, name: r.name) }.first
    }
    
    public func findFolder(_ name: String) throws -> Folder? {
        return try list(path: path, hasFile: false, hasFolder: true).filter {$0.name == name}.map { r in StdFolder(parent: self, name: r.name) }.first
    }
    
    public func get(_ name: String) throws -> Resource {
        return try list(path: path, hasFile: true, hasFolder: true).filter {$0.name == name}.map(self.map(native:)).first ?? StdResource(parent: self, name: name)
    }
    
    public func getFile(_ name: String) -> File {
        return StdFile(parent: self, name: name)
    }
    
    public func getFolder(_ name: String) -> Folder {
        return StdFolder(parent: self, name: name)
    }
    
    public func createFile(_ name: String, data: Data) throws -> File {
        let file = StdFile(path: path + "/" + name)
        try file.create().write(data: data)
        return file
    }
    
    public func createFolder(_ name: String) throws -> Folder {
        let folder: Folder = StdFolder(path: path + "/" + name)
        try folder.create()
        return folder
    }
    
    public func deleteFile(_ name: String) throws -> Self {
        try NativeFileSystem.removeFile(path: path + "/" + name)
        return self
    }
    
    public func deleteFolder(_ name: String, deep: Bool) throws -> Self {
        try NativeFileSystem.removeFolder(path: path + "/" + name, deep: deep)
        return self
    }
    
    public override func delete(deep: Bool) throws -> Self {
        try NativeFileSystem.removeFolder(path: path, deep: deep)
        return self
    }
    
    public func create() throws {
        try NativeFileSystem.createFolder(path: path)
    }
    
    public func createIfNotExist() throws -> Self {
        if !exist { _ = try create() }
        return self
    }
    
    public override var folder: Bool {
        return true
    }
    
}
