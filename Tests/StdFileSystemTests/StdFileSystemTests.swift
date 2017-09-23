import XCTest
@testable import StdFileSystem

class StdFileSystemTests: XCTestCase {
    
    func testExist() throws {
        let fs = StdFileSystem()
        for item in try fs.home().list() {
            XCTAssertTrue(item.exist)
        }
    }
    
    func testList() {
        let fs = StdFileSystem()
        try XCTAssertTrue(fs.home().listFolders().count > 0)
        try XCTAssertTrue(fs.home().list().count > 0)
    }
    
    func testPath() {
        let fs = StdFileSystem()
        XCTAssertEqual("/Users/test", fs.folder("/Users/test").path)
    }
    
}
