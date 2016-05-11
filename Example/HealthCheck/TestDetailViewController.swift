import Foundation
import HealthCheck
import UIKit

class TestDetailViewController: UIViewController {

    var test: Test?

    @IBOutlet weak var TestNameLabel: UILabel!
    @IBOutlet weak var TestNameDetail: UILabel!
    @IBOutlet weak var TestDescriptionLabel: UILabel!
    @IBOutlet weak var TestDescriptionDetail: UILabel!
    @IBOutlet weak var ErrorReasonLabel: UILabel!
    @IBOutlet weak var ErrorReasonDetail: UILabel!
    @IBOutlet weak var ErrorProposedFixLabel: UILabel!
    @IBOutlet weak var ErrorProposedFixDetail: UILabel!
    @IBOutlet weak var ErrorTechnicalDetailsLabel: UILabel!
    @IBOutlet weak var ErrorTechnicalDetailsDetail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let test = test {
            TestNameDetail.text = test.name()
            TestDescriptionDetail.text = test.description()
            if let error = test.lastResult?.error {
                ErrorReasonDetail.text = error.reason
                ErrorProposedFixDetail.text = error.proposedFix
                ErrorTechnicalDetailsDetail.text = error.technicalDetails
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
