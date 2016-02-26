import UIKit
import XCTest
import HealthCheck

class TestXMLRPCConnectionCall: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWorkingConnection() {
        let test = TestXMLRPCConnection(siteURL:NSURL(string:"http://iostest.wpsandbox.me")!)
        let expectation = expectationWithDescription("Request should be fullfilled")
        var testResult = false
        var testError: TestError?
        test.run { (success, error) -> () in
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

    func test404Failure() {
        let test = TestXMLRPCConnection(siteURL:NSURL(string:"http://xmlrpc404.artin.org")!)
        let expectation = expectationWithDescription("Request should be fullfilled")
        var testResult = false
        var testError: TestError?
        test.run { (success, error) -> () in
            expectation.fulfill()
            testResult = success
            testError = error
        }
        waitForExpectationsWithTimeout(5) { (error ) -> Void in
            print(error);
        }
        XCTAssert(testResult == false, "Test should have failed.")
        XCTAssert(testError != nil, "Error should be available.")
    }

}
