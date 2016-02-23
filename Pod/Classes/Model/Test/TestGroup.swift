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
    //typealias Result = (success: Bool, errorDescription: String?) -> ()
    
    let tests : [Test]
    
    /// The progress object for when tests are being run.
    ///
    let progress = NSProgress()
    
    init(tests : [Test]) {
        self.tests = tests
    }
    
    // MARK: - Running & resetting
    
    /// Runs all the tests in this test group.
    ///
    func runAll() {
        for test in tests {
            
            let result = {(test: Test, success: Bool) -> () in
            }
            
            test.run(result)
            
            if test === test {
                
            }
        }
    }
    
    /// Resets the state of all tests in this group.  Should be called before running the test again.
    ///
    func resetAll() {
        for test in tests {
            test.reset()
        }
    }
}