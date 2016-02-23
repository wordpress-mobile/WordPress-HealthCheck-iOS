import Foundation

class TestGroup {

    /// The result block for running all tests.
    ///
    /// - Parameters:
    ///     - success: will be true only if all tests in the group succeeded.
    ///     - errorDescription: will be nil if no test in the group failed.  Contains a user-ready
    ///         and localized description of the errors found in the tests run, and a proposed
    ///         solution on how to fix those errors.
    ///
    typealias GroupCompletionHandler = (success: Bool) -> ()

    /// The tests in this group.
    ///
    let tests: [Test]
    
    /// Default initializer
    ///
    init(tests : [Test]) {
        self.tests = tests
    }
    
    // MARK: - Running & resetting
    
    /// Runs all the tests in this test group.
    ///
    /// - Parameters:
    ///     - onTestComplete: will be executed once for every test in the group.
    ///     - onGroupCmplete: will be executed on time, once all tests in the group have executed.
    ///
    func runAll(
        onTestComplete: TestCompletionHandler,
        onGroupComplete: GroupCompletionHandler) {
        
        let testsToRun = tests.count
        var testsRun = 0
        var anyTestFailed = false
        
        for test in tests {
            test.run({(test: Test, success: Bool) -> () in
                
                onTestComplete(test: test, success: success)
                
                if (!success) {
                    anyTestFailed = true
                }
                
                testsRun += 1
                assert(testsRun <= testsToRun)
                
                if testsRun == testsToRun {
                    onGroupComplete(success: !anyTestFailed)
                }
            })
        }
    }
    
    /// Resets the results of all tests in this group.
    ///
    func resetResults() {
        for test in tests {
            test.result = nil
        }
    }
}