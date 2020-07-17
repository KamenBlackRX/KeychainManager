import XCTest
@testable import KeychainManager

final class KeychainManagerTests: XCTestCase {
    let firstName = "Foo"
    let keychain = KeychainManager(for: Bundle.main)
    
    func testSaveLoadValueFromKey() {
        XCTAssertEqual(keychain.save(firstName,forKey: CommonKeys.firstName.rawValue), true)
    }
    
    func testLoadValueFromKey() {
        let result: String = keychain.load(forKey: CommonKeys.firstName.rawValue)
        XCTAssertEqual(result, firstName)
    }

    static var allTests = [
        ("saveLoadValueFromKey", testSaveLoadValueFromKey),
        ("testLoadValueFromKey", testLoadValueFromKey),
    ]
}
