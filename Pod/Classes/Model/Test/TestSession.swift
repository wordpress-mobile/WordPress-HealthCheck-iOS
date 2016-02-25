import Foundation

/// This represents the universe of `TestGroup` objects to run.  The idea behind this class is to 
/// group all the necessary logic for actually running tests, and receiving updates on the progress
/// through the provided blocks.
///
public class TestSession {
    
    public typealias GroupCompletionHandler = (index: Int, success: Bool) -> ()
    
    // MARK - Tests
    
    let testGroups: [TestGroup]
    
    // MARK: - Initializers
    
    public init(testGroups: [TestGroup])
    {
        self.testGroups = testGroups
    }
    
    // MARK: - Running the tests
    
    /// Execute this method to run all tests.
    ///
    public func runAll(
        onTestCompletion onTestCompletion: TestGroup.TestCompletionHandler,
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
        startingAtIndex index: Int,
        onTestCompletion: TestGroup.TestCompletionHandler,
        onGroupCompletion: GroupCompletionHandler) {
        
        assert(index < testGroups.count)
        
        let privateGroupCompletionHandler = {[weak self] (success: Bool) -> () in
            guard let strongSelf = self else {
                return
            }
            
            onGroupCompletion(index: index, success: success)
            
            if success {
                let nextIndex = index + 1
                
                if nextIndex < strongSelf.testGroups.count {
                    strongSelf.runAll(
                        startingAtIndex: nextIndex,
                        onTestCompletion: onTestCompletion,
                        onGroupCompletion: onGroupCompletion)
                }
            }
        }
        
        testGroups[index].runAll(
            onTestCompletion: onTestCompletion,
            onGroupCompletion: privateGroupCompletionHandler)
    }
}