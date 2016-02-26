import Foundation

public class HTTPSession {
    
    typealias RequestFailure = (data: NSData?, response: NSURLResponse?, error : NSError) -> ()
    
    let sessionConfiguration: NSURLSessionConfiguration
    let session: NSURLSession
    var baseURL: String?
    
    public convenience init() {
        self.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    public required init(sessionConfiguration:NSURLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
        self.session = NSURLSession(configuration: self.sessionConfiguration)
    }
    
    func request<T: Converter where T.ConverterInputType == NSData>(
        method:Method,
        path: String,
        parameters: [String: AnyObject]? = nil,
        parameterEncoding: ParameterEncoding = .URL,
        deserializer: T,
        success: (output : T.ConverterOutputType) -> (),
        failure: RequestFailure) -> NSURLSessionDataTask?
    {
        var fullPath = path
        
        if let baseURL = baseURL {
            fullPath = baseURL + fullPath
        }
        
        guard let url = NSURL(string: fullPath) else {
            failure(data:nil, response: nil, error: Error(code: .InvalidURL))
            return nil
        }
        
        let request = self.dynamicType.encodedRequestForUrl(
            url,
            method: method,
            encoding: parameterEncoding,
            parameters: parameters,
            failure: { (error) -> () in
                failure(data:nil, response: nil, error: error)
        })
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error ) in
            
            self.handleDataTaskCompletion(
                data,
                response: response,
                error: error,
                deserializer: deserializer,
                success: success,
                failure: failure)
        })
        dataTask.resume()
        return dataTask
    }
    
    private func handleDataTaskCompletion<T: Converter where T.ConverterInputType == NSData>(
        data: NSData?,
        response: NSURLResponse?,
        error: NSError?,
        deserializer: T,
        success: (output : T.ConverterOutputType) -> (),
        failure: RequestFailure)
    {
        if let error = error {
            failure(data: data, response: response, error: error)
            return
        }
        
        if isResponseAFailure(response) {
            var failureCode: Error.Code = .StatusCodeValidationFailed
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                    
                case 401: failureCode = .StatusCodeInvalid401Unauthorized
                case 403: failureCode = .StatusCodeInvalid403Forbidden
                case 404: failureCode = .StatusCodeInvalid404NotFound
                default: failureCode = .StatusCodeInvalid
                }
            }
            failure(data: data, response: response, error:Error(code: failureCode))
            return
        }
        
        guard let data = data where data.length > 0 else {
            failure(data: nil, response: response, error: Error(code: .DataSerializationFailed))
            return
        }
        
        do {
            let output = try deserializer.convert(data)
            
            success(output: output)
            
        } catch let error as NSError {
            failure(data: data, response: response, error: error)
        }
    }
    
    private func isResponseAFailure(response: NSURLResponse?) -> Bool {
        
        guard let response = response else {
            return true
        }
        
        if let httpResponse = response as? NSHTTPURLResponse {
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                return true
            }
        }
        
        return false
    }
    
    /// Returns a request encoded with the specified encoding, using the specified URL, method and
    /// parameters.
    ///
    /// - Parameters:
    ///     - url: the URL for the request.
    ///     - method: the request method.
    ///     - encoding: the encoding object to use.
    ///     - parameters: the parameters for the request.
    ///     - failure: a block to execute on failure.
    ///
    /// - Returns: the encoded request.
    ///
    static func encodedRequestForUrl(
        url: NSURL,
        method: Method,
        encoding: ParameterEncoding,
        parameters: [String: AnyObject]?,
        failure: (error : NSError) -> ()) -> NSURLRequest {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = method.rawValue
            
            let encodingResult = encoding.encode(request, parameters: parameters)
            
            if let error = encodingResult.error {
                failure(error: error)
            }
            
            return encodingResult.request
    }
    
}

extension HTTPSession {
    
    public class Error : NSError {
        
        /// The domain used for creating all networks errors.
        public static let domain = "com.WordPress.HTTPSession.Error"
        
        // MARK: - Error codes
        
        /// The custom error codes generated by the network calls.
        public enum Code: Int {
            case InputStreamReadFailed           = -6000
            case OutputStreamWriteFailed         = -6001
            case ContentTypeValidationFailed     = -6002
            case StatusCodeValidationFailed      = -6003
            case DataSerializationFailed         = -6004
            case StringSerializationFailed       = -6005
            case PropertyListSerializationFailed = -6007
            case InvalidURL = -6008
            case StatusCodeInvalid = -7000
            case StatusCodeInvalid401Unauthorized = -7401
            case StatusCodeInvalid403Forbidden = -7403
            case StatusCodeInvalid404NotFound = -7404
            
            func localizedFailureReason() -> String {
                switch self {
                case InputStreamReadFailed:
                    return NSLocalizedString("The returned data is not an image.", comment: "InputStreamReadFailed localized error message")
                    
                case StatusCodeValidationFailed:
                    return NSLocalizedString("Unexpected status code on answer", comment: "StatusCodeValidationFailed localized error message")
                    
                case DataSerializationFailed:
                    return NSLocalizedString("No data in the answer", comment: "DataSerializationFailed localized error message")
                    
                case InvalidURL:
                    return NSLocalizedString("Invalid URL for request.", comment: "InvalidURL localized error message")
                    
                case .StatusCodeInvalid:
                    return NSLocalizedString("Unexpected status code on answer", comment: "StatusCodeValidationFailed localized error message")
                case .StatusCodeInvalid401Unauthorized:
                    return NSLocalizedString("Unauthorized.", comment: "HTTP 401 error code localized error message")
                case .StatusCodeInvalid403Forbidden:
                    return NSLocalizedString("Request Forbidden.", comment: "HTTP 403 error code localized error message")
                case .StatusCodeInvalid404NotFound:
                    return NSLocalizedString("Not Found.", comment: "HTTP 404 error code localized error message")

                default:
                    return NSLocalizedString("Unexpected error.", comment: "Unexpected networking error.")
                }
            }
        }
        
        // MARK: - Initializers
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(code: Code) {
            
            let userInfo = [NSLocalizedFailureReasonErrorKey: code.localizedFailureReason()]
            
            super.init(domain: Error.domain, code: code.rawValue, userInfo: userInfo)
        }
    }
}
