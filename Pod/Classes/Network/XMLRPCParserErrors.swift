/// Class for handling errors related to the XMLRPC parsing.
///
enum XMLRPCParserErrors: ErrorType, CustomDebugStringConvertible, CustomStringConvertible {
    
    case ExpectedDictionary
    case ExpectedArray
    
    func localizedFailureReason() -> String {
        switch self {
        case .ExpectedDictionary:
            return NSLocalizedString("Expected to find Dictionary in XML response.", comment: "Error message to show when reading from a JSON object and a expected dictionary is not found.")
        case .ExpectedArray:
            return NSLocalizedString("Expected to find Array in XML response.", comment: "Error message to show when reading from a JSON object and a expected array is not found.")
        }
    }
    
    func convertToNSError() -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: self.localizedFailureReason()]
        return NSError(domain: "JSONValidationErrors", code: self._code, userInfo: userInfo)
    }
    
    var description:String{ get { return localizedFailureReason() }}
    
    var debugDescription:String{ get { return localizedFailureReason() }}
}