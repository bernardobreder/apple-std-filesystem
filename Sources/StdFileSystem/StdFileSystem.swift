//
//  StdFileSystem.swift
//  codegenv
//
//  Created by Bernardo Breder on 13/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import FileSystem
#endif
    
open class StdFileSystem: FileSystem {
    
    public init() {
    }
    
    public func cwd() throws -> Folder {
        return StdFolder(path: try NativeFileSystem.cwd())
    }
    
    public func home() throws -> Folder {
        return StdFolder(path: try NativeFileSystem.home())
    }
    
    public func folder(_ path: String) -> Folder {
        if let range = path.range(of: "/", options: .backwards) {
            var parent: String? = path.substring(to: range.lowerBound)
            if parent == "" { parent = nil }
            let name = path.substring(from: range.upperBound)
            if let hasParent = parent {
                return StdFolder(parent: folder(hasParent), name: name)
            } else {
                return StdFolder(parent: nil, name: name)
            }
        } else { return StdFolder(path: path) }
    }
    
    public func file(_ path: String) -> File {
        if let range = path.range(of: "/", options: .backwards) {
            var parent: String? = path.substring(to: range.lowerBound)
            if parent == "" { parent = nil }
            let name = path.substring(from: range.upperBound)
            if let hasParent = parent {
                return StdFile(parent: folder(hasParent), name: name)
            } else {
                return StdFile(parent: nil, name: name)
            }
        } else { return StdFile(path: path) }
    }
    
}
