//
//  StdFile.swift
//  codegenv
//
//  Created by Bernardo Breder on 13/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import FileSystem
#endif

open class StdFile: StdResource, File {
    
    public func read() throws -> Data {
        return try NativeFileSystem.read(path: path)
    }
    
    @discardableResult
    public func write(data: Data) throws -> Self {
        try NativeFileSystem.write(path: path, data: data)
        return self
    }
    
    @discardableResult
    public func append(data: Data) throws -> Self {
        try NativeFileSystem.append(path: path, data: data)
        return self
    }
    
    @discardableResult
    public override func delete(deep: Bool) throws -> Self {
        try NativeFileSystem.removeFile(path: path)
        return self
    }
    
    @discardableResult
    public func create() throws -> Self {
        NativeFileSystem.createFile(path: path)
        return self
    }
    
    @discardableResult
    public func createIfNotExist() throws -> Self {
        if !exist { _ = try create() }
        return self
    }
    
    public override var file: Bool {
        return true
    }
    
}
