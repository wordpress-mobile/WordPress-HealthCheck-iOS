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
    
    func testExample() {
        let testXMLRCAllMethods = TestXMLRPCAllMethods(siteURL:NSURL(string:"http://iostest.wpsandbox.me")!)
        let expectation = expectationWithDescription("Request should be fullfilled")
        testXMLRCAllMethods.run { (test, success) -> () in
            print("test runned");
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5) { (error ) -> Void in
            print(error);
        }
        XCTAssert(true, "Pass")
    }
        
}
