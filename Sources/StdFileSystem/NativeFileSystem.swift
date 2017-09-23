//
//  NativeFileSystem.swift
//  codegenv
//
//  Created by Bernardo Breder on 13/11/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import FileSystem
#endif

public enum NativeResourceType {
    
    case File, Folder, Symbol
    
}

public struct NativeResource {
    
    public let name: String
    
    public let type: NativeResourceType
    
}

open class NativeFileSystem {
    
    public class func exist(path: String) -> Bool {
        let fm = FileManager.default
        guard fm.fileExists(atPath: path) else { return false }
        return true
    }
    
    public class func fileType(path: String) -> NativeResourceType? {
        guard let attr = try? FileManager.default.attributesOfItem(atPath: path) else { return nil }
        guard let filetype: FileAttributeType = attr[FileAttributeKey.type] as? FileAttributeType else { return nil }
        switch filetype {
        case FileAttributeType.typeSymbolicLink: return .Symbol
        case FileAttributeType.typeDirectory: return .Folder
        case FileAttributeType.typeRegular: return .File
        default: return nil
        }
    }
    
    public class func list(path: String, hasFile: Bool, hasFolder: Bool) throws -> [NativeResource] {
        return try FileManager.default.contentsOfDirectory(atPath: path).map { (name: String) -> NativeResource? in
            let childPath = path + "/" + name
            guard let type = fileType(path: childPath) else { return nil }
            if type == .Folder || type == .Symbol { guard hasFolder else { return nil } }
            if type == .File { guard hasFile else { return nil } }
            return NativeResource(name: name, type: type)
            }.notnil()
    }
    
    public class func home() throws -> String {
        if let home: UnsafeMutablePointer<Int8> = getenv("HOME") {
            if let result = String(validatingUTF8: home) { return result }
        }
        return try cwd()
    }
    
    public class func home(name: String) throws -> String {
        return try home() + "/." + name
    }
    
    public class func cwd() throws -> String {
        guard let cwd: UnsafeMutablePointer<Int8> = getcwd(nil, Int(PATH_MAX)) else { throw FileSystemError.currentWorkingFolder }
        defer { free(cwd) }
        guard let path: String = String(validatingUTF8: cwd) else { throw FileSystemError.utf8 }
        return path
    }
    
    public class func createFile(path: String, data: Data = Data()) {
        _ = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    public class func createFolder(path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    public class func read(path: String) throws -> Data {
        guard let data = FileManager.default.contents(atPath: path) else { throw FileSystemError.readFile(path) }
        return data
    }
    
    public class func write(path: String, data: Data) throws {
        try data.write(to: URL.init(fileURLWithPath: path))
    }
    
    public class func append(path: String, data: Data) throws {
        guard let fh = FileHandle.init(forWritingAtPath: path) else { throw FileSystemError.openFile(path) }
        _ = fh.seekToEndOfFile()
        fh.write(data)
        fh.closeFile()
    }
    
    public class func removeFile(path: String) throws {
        if exist(path: path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
    
    public class func removeFolder(path: String, deep: Bool) throws {
        if deep {
            for name in try FileManager.default.contentsOfDirectory(atPath: path) {
                let childPath = path + "/" + name
                if let type = fileType(path: childPath), type == .Folder {
                    try removeFolder(path: childPath, deep: deep)
                } else {
                    try removeFile(path: childPath)
                }
            }
        }
        try FileManager.default.removeItem(atPath: path)
    }
    
}

