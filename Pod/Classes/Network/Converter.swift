
/// A protocol for classes that convert objects from an input type to an output type.
///
protocol Converter {
    
    /// The type of the initial object that will be provided to this deserializer.
    ///
    typealias ConverterInputType
    
    /// The type of the final object that will be provided by this deserializer.
    ///
    typealias ConverterOutputType
    
    /// Converts the from the input type to the output type.
    ///
    /// - Parameters:
    ///     - input: the input object to convert.
    ///
    /// - Returns: the converted object.
    ///
    func convert(input : ConverterInputType) throws -> ConverterOutputType
}