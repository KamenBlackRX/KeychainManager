import XCTest
@testable import KeychainManager

final class KeychainManagerTests: XCTestCase {
    let firstName = "Foo"
    let keychain = KeychainManager(for: Bundle.main)
    
    func testSaveLoadValueFromKey() {
        do{
            let result = try keychain.save(self.firstName,forKey: CommonKeys.firstName.rawValue)
            XCTAssertEqual(result, true)
        } catch KeySecErrors.MissingEntitlement {
            XCTFail("An internal error has occured, refer to \(KeySecErrors.MissingEntitlement)")
        } catch {
            XCTFail("An internal error has occured, refer to: Unknow error")
        }
    }
    
    func testLoadValueFromKey() {
    }
    
    static var allTests = [
        ("saveLoadValueFromKey", testSaveLoadValueFromKey),
        ("testLoadValueFromKey", testLoadValueFromKey),
    ]
}
