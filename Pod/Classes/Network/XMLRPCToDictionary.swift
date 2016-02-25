import Foundation
import wpxmlrpc

/// Generic class for converting XMLRPC data to a Dictionary.  The root object must be an dictionary for this
/// conversion to work.
///
class XMLRPCToDictionaryConverter : Converter {
    
    // MARK: - Converter protocol compliance
    
    typealias ConverterInputType = NSData
    typealias ConverterOutputType = [String:AnyObject]
    
    /// Converts XMLRPC data to an dictionary
    ///
    /// - Parameters:
    ///     - data: the XMLRPC data to convert.
    ///
    /// - Returns: the data as an dictionary.
    ///
    func convert(data: NSData) throws -> ConverterOutputType {
        let xmlRPCDecoder = WPXMLRPCDecoder(data: data)
        if xmlRPCDecoder.isFault() || xmlRPCDecoder.object() == nil {
            throw xmlRPCDecoder.error()
        }
        guard let dictionary  = xmlRPCDecoder.object() as? ConverterOutputType else {
            throw XMLRPCParserErrors.ExpectedDictionary.convertToNSError()
        }
        
        return dictionary
    }
}