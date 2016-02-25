import UIKit
import HealthCheck

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var hostTextView: UITextField!
    @IBOutlet private var passwordTextView: UITextField!
    @IBOutlet private var userTextView: UITextField!
    
    // MARK: - Login info
    
    private var loginInfo: LoginInfo?
    
    // MARK: - IBActions
    
    @IBAction func startTouchUpInside() {
        
        guard let hostname = hostTextView.text where hostname != "",
            let username = userTextView.text where username != "",
            let password = passwordTextView.text where password != "" else
        {
            loginInfo = nil
            return
        }
        
        self.loginInfo = LoginInfo(host: hostname, username: username, password: password)
        
        performSegueWithIdentifier("ShowTestsViewController", sender: self)
    }
    
    // MARK: - Preparing for segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let testsViewController = segue.destinationViewController as! TestsViewController
        
        testsViewController.loginInfo = loginInfo
    }
}

