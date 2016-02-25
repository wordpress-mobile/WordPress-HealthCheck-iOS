import Foundation
import wpxmlrpc

enum XMLRPCFunctions: String {
    case ListMethods = "system.listMethods"
}

typealias RequestFailure = (error : NSError) -> ()
typealias RequestDictionarySuccess = (dictionary : [String:AnyObject]) -> ()
typealias RequestArraySuccess = (array : [AnyObject]) -> ()

class XMLRPCSession
{
    private let siteURL: NSURL
    private var user: String?
    private var password: String?
    
    init(siteURL: NSURL, user:String? = nil, password:String? = nil) {
        self.siteURL = siteURL
        self.user = user
        self.password = password
    }
    
    
    private lazy var httpSession: HTTPSession = {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var httpAdditionalHeaders = ["Content-Type": "application/xml"]
        if let user = self.user,
            let password = self.password {
                let authStr = "\(user):\(password)"
                let authData = authStr.dataUsingEncoding(NSUTF8StringEncoding)
                let authValue = "Basic \(authData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))"
                httpAdditionalHeaders["Authorization"] = authValue
        }
        sessionConfiguration.HTTPAdditionalHeaders = httpAdditionalHeaders
        sessionConfiguration.URLCache = nil
        let httpSession = HTTPSession(sessionConfiguration: sessionConfiguration)
        httpSession.baseURL = self.siteURL.absoluteString
        return httpSession
    }()
    
    func requestDictionary(method:XMLRPCFunctions, parameters:[String:AnyObject] = [String:AnyObject](), success: RequestDictionarySuccess, failure: RequestFailure) {
        httpSession.request(.POST,
            path: "/xmlrpc.php",
            parameters: parameters,
            parameterEncoding:.XMLRPC(method.rawValue),
            deserializer: XMLRPCToDictionaryConverter(),
            success: { (output) -> () in
                success(dictionary: output)
            },
            failure: { (data, response, error) -> () in
                failure(error: error)
            }
        )
    }

    func requestArray(method:XMLRPCFunctions, parameters:[String:AnyObject] = [String:AnyObject](), success: RequestArraySuccess, failure: RequestFailure) {
        httpSession.request(.POST,
            path: "/xmlrpc.php",
            parameters: parameters,
            parameterEncoding:.XMLRPC(method.rawValue),
            deserializer: XMLRPCToArrayConverter(),
            success: { (output) -> () in
                success(array: output)
            },
            failure: { (data, response, error) -> () in
                failure(error: error)
            }
        )
    }

    func listMethods(success: RequestArraySuccess, failure: RequestFailure)
    {
        requestArray(.ListMethods, success: success, failure: failure)
    }
}