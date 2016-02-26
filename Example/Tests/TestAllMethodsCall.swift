import UIKit
import XCTest
import HealthCheck

class TestAllMethodsCall: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllCallsAvailable() {
        let testXMLRCAllMethods = TestXMLRPCAllMethods(siteURL:NSURL(string:"http://iostest.wpsandbox.me")!)
        let expectation = expectationWithDescription("Request should be fullfilled")
        var testResult = false
        var testError: TestError?
        testXMLRCAllMethods.run { (success, error) -> () in
            expectation.fulfill()
            testResult = success
            testError = error
        }
        waitForExpectationsWithTimeout(5) { (error ) -> Void in
            print(error);
        }
        XCTAssert(testResult, "Test should have passed.")
        XCTAssert(testError == nil, "Error should be nil.")
    }
        
}
