import Foundation


public class TestXMLRPCAllMethods: Test
{
    public var result:TestResult?
    
    var session: XMLRPCSession
    
    public init(siteURL: NSURL, user: String? = nil, password: String? = nil) {
        session = XMLRPCSession(siteURL: siteURL, user: user, password: password)
    }
    
    public func name() -> String {
        return "Test if XMLRPC is there"
    }
    
    public func description() -> String {
        return "Tries to connect to the server to see if the XML-RPC returns a response"
    }
    
    public func run(onComplete: TestCompletionHandler) {
        session.listMethods({ (array) -> () in
            print(array)
            onComplete(test: self, success: true);
            self.result = TestResult(test: self, success: true, error: nil)
        }, failure:  { (error) -> () in
            print(error)
            self.result = TestResult(test: self, success: false, error:TestResult.Error(description: error.localizedDescription, workaround: "Cross your fingers and try again"))
        })
        
    }
    
    
}