import Foundation

/// Storage for test group results.
///
public class TestGroupResult {
    
    /// The result of the test.
    ///
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}