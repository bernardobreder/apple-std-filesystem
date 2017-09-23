//
//  StdResource.swift
//  codegenv
//
//  Created by Bernardo Breder on 13/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import FileSystem
#endif

open class StdResource: Resource {
    
    public private(set) var name: String
    
    public private(set) var path: String
    
    private let parentPath: String?
    
    public init(parent: Folder?, name: String) {
        self.name = name
        self.path = (parent?.path ?? "") + "/" + name
        self.parentPath = parent?.path
    }
    
    public init(path: String) {
        self.path = path
        if let range: Range = path.range(of: "/", options: .backwards) {
            self.name = path.substring(from: range.upperBound)
            let parentPath = path.substring(to: range.lowerBound)
            self.parentPath = parentPath == "" ? nil : parentPath
        } else {
            self.name = path
            self.parentPath = nil
        }
    }
    
    public var canBeRead: Bool {
        return FileManager.default.isReadableFile(atPath: path)
    }
    
    public var canBeWrite: Bool {
        return FileManager.default.isWritableFile(atPath: path)
    }
    
    public var exist: Bool {
        return NativeFileSystem.exist(path: path)
    }
    
    public var parent: Folder? {
        guard let parentPath: String = self.parentPath else { return nil }
        return StdFolder(path: parentPath)
    }
    
    public var file: Bool {
        return false
    }
    
    public var folder: Bool {
        return false
    }
    
    public func asFile() -> File {
        return self as! File
    }
    
    public func asFolder() -> Folder {
        return self as! Folder
    }
    
    public func delete(deep: Bool) throws -> Self {
        if let parent = self.parent {
            if file {
                try parent.deleteFile(name)
            } else if folder {
                try parent.deleteFolder(name, deep: deep)
            }
        }
        return self
    }
    
    public func delete() throws -> Self {
        return try delete(deep: true)
    }
    
}

extension StdResource: CustomStringConvertible {
    
    public var description: String {
        return path
    }
    
}
