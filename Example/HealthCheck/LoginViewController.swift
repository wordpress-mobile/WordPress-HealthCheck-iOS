import UIKit
import HealthCheck

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var hostTextView: UITextField!
    @IBOutlet private var passwordTextView: UITextField!
    @IBOutlet private var userTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startTouchUpInside() {
        
        guard let hostname = hostTextView.text,
            let username = userTextView.text,
            let password = passwordTextView.text else
        {
            // TODO: at some point we should show an error message here...
            return
        }
        
        let loginInfo = LoginInfo(host: hostname, username: username, password: password)
        
    }
}

