import Foundation

/// Storage for test results.  Used by the session object.
///
public class TestResult {
    
    /// The error provided by the test.  This should never be nil if `success` is `false`.
    ///
    public let error: TestError?
    
    /// The result of the test.
    ///
    public let success: Bool
    
    public init(success: Bool, error: TestError?) {
        assert(success || error != nil)
        
        self.error = error
        self.success = success
    }
}