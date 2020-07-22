import XCTest
@testable import KeychainManager

final class KeychainManagerTests: XCTestCase {
    func testExample() {
        let km = KeychainManager(for: Bundle.main)
        let saveStatus = try? km.save("Foo", forKey: CommonKeys.firstName.rawValue)
        
        XCTAssertEqual( saveStatus, true)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
