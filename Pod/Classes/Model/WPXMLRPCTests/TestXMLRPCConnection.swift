import Foundation


public class TestXMLRPCConnection: Test
{
    var session: XMLRPCSession
    var siteURL: NSURL
    public var lastResult: TestResult?
    
    public init(siteURL: NSURL, user: String? = nil, password: String? = nil) {
        self.siteURL = siteURL
        session = XMLRPCSession(siteURL: siteURL, user: user, password: password)
    }
    
    public func name() -> String {
        return "Test if XMLRPC list methods has all avaible methods that the app needs to use."
    }
    
    public func description() -> String {
        return "Tries to connect to the server to see if the XML-RPC returns a response"
    }
    
    public func run(onCompletion onCompletion: TestCompletionHandler) {
        session.listMethods({ (array) -> () in
            self.lastResult = TestResult(success: true, error: nil)
            onCompletion(success: true, error: nil)
        }, failure:  { (error) -> () in
            print(error)
            var reason = "Unable to connect to the server \(self.siteURL)"
            var proposedFix = "This is unknow connection error so we don't have a solution for it."
            let technicalDetails = error.localizedDescription
            
            if (error.domain == HTTPSession.Error.domain) {
                switch error.code {
                case HTTPSession.Error.Code.StatusCodeInvalid404NotFound.rawValue:
                    reason = "Got a 404 status code when tried to connect to the server"
                    proposedFix = "Contact you hosting adming to fix permission for accessing the xmlrpc.php file"
                case HTTPSession.Error.Code.StatusCodeInvalid403Forbidden.rawValue:
                    reason = "Got a 403 status code when tried to connect to the server"
                    proposedFix = "Contact you hosting adming to fix permission for accessing the xmlrpc.php file"
                case HTTPSession.Error.Code.StatusCodeInvalid401Unauthorized.rawValue:
                    reason = "Got a 401 status code when tried to connect to the server"
                    proposedFix = "Contact you hosting adming to fix permission for accessing the xmlrpc.php file"
                default:
                    reason = "Got another connection error."
                    proposedFix = "Contact you hosting adming to fix permission for accessing the xmlrpc.php file"
                }
            }
            let testError = TestError(reason: reason,
                proposedFix: proposedFix,
                technicalDetails: technicalDetails)
            self.lastResult = TestResult(success: false, error: testError)
            onCompletion(success: false, error: testError)
        })
        
    }
    
    
}