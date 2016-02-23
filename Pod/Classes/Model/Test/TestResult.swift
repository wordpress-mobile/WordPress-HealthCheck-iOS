/// Stores information about a test result.
///
class TestResult {
    
    let error: Error?
    let test: Test
    let success: Bool
    
    init(test: Test, success: Bool, error: Error?) {
        self.test = test
        self.success = false
        self.error = error
    }
}

extension TestResult {
    /// This class is used to describe errors in detail.  It contains information that's ready for
    /// user consumption and for generating reports for bug reports.
    ///
    class Error {
        
        /// Description of the error.  Must be localized and user-ready.
        ///
        let description: String
        
        /// Workaround.
        let workaround: String
        
        init(description: String, workaround: String) {
            self.description = description
            self.workaround = workaround
        }
    }
}