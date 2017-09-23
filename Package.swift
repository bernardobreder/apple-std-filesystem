//
//  Package.swift
//  StdFileSystem
//
//

import PackageDescription

let package = Package(
	name: "StdFileSystem",
	targets: [
		Target(name: "StdFileSystem", dependencies: ["FileSystem", "Optional", "Stream"]),
		Target(name: "FileSystem", dependencies: []),
		Target(name: "Optional", dependencies: []),
		Target(name: "Stream", dependencies: []),
	]
)

