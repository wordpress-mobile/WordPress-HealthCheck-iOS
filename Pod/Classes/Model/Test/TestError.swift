/// This class is used to describe errors in detail.  It contains information that's ready for
/// user consumption and for generating reports for bug reports.
///
public class TestError {
    
    /// Reason of the error.  Must be localized and user-ready.
    ///
    public let reason: String
    
    /// Proposed fix for the error.  Must be localized and user-ready.
    ///
    public let proposedFix: String
    
    /// Technical log of the error. Localization is not important, since this message is intended
    /// for support.
    ///
    public let technicalDetails: String
    
    public init(
        reason: String,
        proposedFix: String,
        technicalDetails: String)
    {
        self.reason = reason
        self.proposedFix = proposedFix
        self.technicalDetails = technicalDetails
    }
}