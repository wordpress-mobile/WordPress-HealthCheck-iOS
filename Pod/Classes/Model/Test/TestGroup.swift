import Foundation

public class TestGroup {

    /// A completion block for single tests inside a group.  More convenient since it also returns
    /// the index of the test.
    ///
    public typealias TestCompletionHandler = (index: Int, success: Bool, error: TestError?) -> ()
    
    /// The result block for running all tests.
    ///
    /// - Parameters:
    ///     - success: will be true only if all tests in the group succeeded.
    ///
    public typealias GroupCompletionHandler = (success: Bool) -> ()

    /// The tests in this group.
    ///
    public let tests: [Test]

    /// The test group name
    ///
    public let name: String

    /// Default initializer
    ///
    public init(name: String, tests : [Test]) {
        self.name = name
        self.tests = tests
    }

    // MARK: - Running & resetting

    /// Runs all the tests in this test group.
    ///
    /// - Parameters:
    ///     - onTestCompletion: will be executed once for every test in the group.
    ///     - onGroupCompletion: will be executed on time, once all tests in the group have executed.
    ///
    public func runAll(
        onTestCompletion onTestCompletion: TestCompletionHandler,
        onGroupCompletion: GroupCompletionHandler) {
        
        runAll(
            startingAtIndex: 0,
            onTestCompletion: onTestCompletion,
            onGroupCompletion: onGroupCompletion)
    }
    
    /// Recursive method to run all tests sequentially.  It's intended as an aid for method
    /// `runAll`.
    ///
    /// - Parameters:
    ///     - index: the index of the first element in the `testGroups` array to run.
    ///
    private func runAll(
        startingAtIndex index: Int,
        onTestCompletion: TestCompletionHandler,
        onGroupCompletion: GroupCompletionHandler)
    {
        assert(index < tests.count)
        
        let privateTestCompletionHandler = {[weak self] (success: Bool, error: TestError?) -> () in
            
            guard let strongSelf = self else {
                return
            }
            
            onTestCompletion(index: index, success: success, error: error)
            
            if strongSelf.isLastTest(index) || !success {
                onGroupCompletion(success: success)
            } else {
                strongSelf.runAll(
                    startingAtIndex: index + 1,
                    onTestCompletion: onTestCompletion,
                    onGroupCompletion: onGroupCompletion)
            }
        }
        
        tests[index].run(onCompletion: privateTestCompletionHandler)
    }
    
    /// Convenience method to check if an index matches that of the last test in the group.
    ///
    /// - Parameters:
    ///     - index: the index of the test to check.
    ///
    /// - Returns: true if the specified index matches the index of the last test.
    ///
    private func isLastTest(index: Int) -> Bool {
        return index == tests.count - 1
    }
}