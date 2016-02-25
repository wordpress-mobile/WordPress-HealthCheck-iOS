import Foundation

/// This represents the universe of `TestGroup` objects to run.  The idea behind this class is to 
/// group all the necessary logic for actually running tests, and receiving updates on the progress
/// through the provided blocks.
///
public class TestSession {
    
    public typealias GroupCompletionHandler = (index: Int, success: Bool) -> ()
    public typealias TestCompletionHandler = (groupIndex: Int, testIndex: Int, success: Bool, error: TestError?) -> ()
    
    // MARK - Tests
    
    public let testGroups: [TestGroup]
    
    // MARK: - Initializers
    
    public init(testGroups: [TestGroup])
    {
        self.testGroups = testGroups
    }

    // MARK: - Running the tests

    /// Execute this method to run all tests.
    ///
    public func runAll(
        onTestCompletion onTestCompletion: TestCompletionHandler,
        onGroupCompletion: GroupCompletionHandler)
    {
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
        startingAtIndex groupIndex: Int,
        onTestCompletion: TestCompletionHandler,
        onGroupCompletion: GroupCompletionHandler)
    {
        assert(groupIndex < testGroups.count)
        
        let privateTestCompletionHandler = {(testIndex: Int, success: Bool, error: TestError?) -> () in
            onTestCompletion(groupIndex: groupIndex, testIndex: testIndex, success: success, error: error)
        }
        
        let privateGroupCompletionHandler = {[weak self] (success: Bool) -> () in
            guard let strongSelf = self else {
                return
            }
            
            onGroupCompletion(index: groupIndex, success: success)
            
            if success {
                let nextIndex = groupIndex + 1
                
                if nextIndex < strongSelf.testGroups.count {
                    strongSelf.runAll(
                        startingAtIndex: nextIndex,
                        onTestCompletion: onTestCompletion,
                        onGroupCompletion: onGroupCompletion)
                }
            }
        }
        
        testGroups[groupIndex].runAll(
            onTestCompletion: privateTestCompletionHandler,
            onGroupCompletion: privateGroupCompletionHandler)
    }
}