import Foundation


public class TestXMLRPCAllMethods: Test
{
    var session: XMLRPCSession
    
    public var lastResult: TestResult?
    
    public init(siteURL: NSURL, user: String? = nil, password: String? = nil) {
        session = XMLRPCSession(siteURL: siteURL, user: user, password: password)
    }
    
    public func name() -> String {
        return "Test if XMLRPC is there"
    }
    
    public func description() -> String {
        return "Tries to connect to the server to see if the XML-RPC returns a response"
    }
    
    public func run(onCompletion onCompletion: TestCompletionHandler) {
        session.listMethods({[weak self] (array) -> () in
            guard let strongSelf = self else {
                return
            }
            
            print(array)
            strongSelf.lastResult = TestResult(success: true, error: nil)
            onCompletion(success: true, error: nil);
        }, failure:  {[weak self] (error) -> () in
            guard let strongSelf = self else {
                return
            }
            
            print(error)
            let error = TestError(reason: error.localizedDescription, proposedFix: "Cross your fingers and try again", technicalDetails: "Do not collect $200")
            
            strongSelf.lastResult = TestResult(success: false, error: error)
            onCompletion(success: false, error: error)
        })
        
    }
}