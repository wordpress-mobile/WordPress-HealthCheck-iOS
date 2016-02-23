import Foundation

/// This class is used to describe errors in detail.  It contains information that's ready for
/// user consumption and for generating reports for bug reports.
///
class TestError {
    
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