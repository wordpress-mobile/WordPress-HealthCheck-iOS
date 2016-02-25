import Foundation
import wpxmlrpc

/// Generic class for converting XMLRPC data to an Array.  The root object must be an array for this
/// conversion to work.
///
class XMLRPCToArrayConverter : Converter {
    
    // MARK: - Converter protocol compliance
    
    typealias ConverterInputType = NSData
    typealias ConverterOutputType = [AnyObject]
    
    /// Converts XMLRPC data to an array
    ///
    /// - Parameters:
    ///     - data: the XMLRPC data to convert.
    ///
    /// - Returns: the data as an array.
    ///
    func convert(data: NSData) throws -> ConverterOutputType {
        let xmlRPCDecoder = WPXMLRPCDecoder(data: data)
        if xmlRPCDecoder.isFault() || xmlRPCDecoder.object() == nil {
            throw xmlRPCDecoder.error()
        }
        guard let array  = xmlRPCDecoder.object() as? ConverterOutputType else {
            throw XMLRPCParserErrors.ExpectedArray.convertToNSError()
        }
        
        return array
    }
}