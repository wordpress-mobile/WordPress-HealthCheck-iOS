import Foundation

/// Can't bring this into the protocol for now due to limitations in how Swift handles the
/// `typealias` keyword.
///
/// - Parameters:
///     - test: convenience reference to the test that completed.
///     - success: whether the test failed or succeeded.  More information can be obtained from the
///         `result` property.
///
public typealias TestCompletionHandler = (test: Test, success: Bool) -> ()

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
    ///     - onComplete: the block that will be executed when the test run completes.
    ///
    func run(onComplete: TestCompletionHandler);

    // MARK: - Test result information

    /// Contains information about the last test result.  This will be set by the parent group to
    /// `nil` before running a new round of tests.
    ///
    var result: TestResult? { set get }
}