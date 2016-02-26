import Foundation

/// The handler that's executed when a test succeeds or fails.
///
/// - Note: Can't bring this into the protocol for now due to limitations in how Swift handles the
/// `typealias` keyword.
///
/// - Parameters:
///     - success: whether the test failed or succeeded.  More information can be obtained from the
///         `result` property.
///     - error: the error found during the execution of the test, or `nil` if no error was found.
///
public typealias TestCompletionHandler = (success: Bool, error: TestError?) -> ()

/// Defined a single test object.
///
public protocol Test : AnyObject {

    // MARK: - Test information

    /// The name of the test.
    ///
    func name() -> String;

    /// This method must return a description of what the test does.
    ///
    func description() -> String;

    // MARK: - Running & resetting

    /// This will be called when the test needs to be executed.
    ///
    /// - Parameters:
    ///     - onCompletion: the block that will be executed when the test run completes.
    ///
    func run(onCompletion onCompletion: TestCompletionHandler);
    
    // MARK: - Test results
    
    var lastResult: TestResult? { set get }
}