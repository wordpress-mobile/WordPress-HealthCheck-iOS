import Foundation
import HealthCheck
import UIKit

class ExampleTest : Test {
    
    var lastResult: TestResult?
    
    func name() -> String {
        return "First test"
    }
    
    func description() -> String {
        return "First test description"
    }
    
    func run(onCompletion onCompletion: TestCompletionHandler)
    {
        sleep(1)
        lastResult = TestResult(success: true, error: nil)
        onCompletion(success: true, error: nil)
    }
}

class TestsViewController : UITableViewController {
    
    private var testSession: TestSession!
    
    /// The login info this VC will use for its tests.
    ///
    /// - Note: Must be set by whoever is creating this VC.
    ///
    var loginInfo: LoginInfo!
    
    override func viewDidLoad() {
        
        let firstTest = ExampleTest()
        let tests: [Test] = [firstTest]
        let demoTestGroup = TestGroup(name: "XMLRPC", tests: tests)
        
        testSession = TestSession(testGroups: [demoTestGroup])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        testSession.runAll(onTestCompletion: {[weak self] (groupIndex, testIndex, success, error) -> () in
            guard let strongSelf = self else {
                return
            }
            
            if (success) {
                strongSelf.markTestSucceeded(groupIndex: groupIndex, testIndex: testIndex)
            } else {
                strongSelf.markTestFailed(groupIndex: groupIndex, testIndex: testIndex, error: error)
            }
        }) { (index, success) -> () in
            // We do nothing now for groups that complete
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return testSession.testGroups.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testSession.testGroups[section].tests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestsViewControllerCell", forIndexPath:  indexPath)
        
        let groupIndex = indexPath.section
        let testIndex = indexPath.row
        
        let test = testSession.testGroups[groupIndex].tests[testIndex]
        
        cell.textLabel?.text = test.name()
        cell.detailTextLabel?.text = test.description()
        
        //updateCellWithResult(cell, result: TestResult)
        
        return cell
    }
    
    // MARK: - Processing test results
    
    private func imageForResult(result: TestResult) -> UIImage {
        if result.success {
            return UIImage(named: "checkmark")!
        } else {
            return UIImage(named: "cross")!
        }
    }
    
    private func markTestSucceeded(groupIndex groupIndex: Int, testIndex: Int) {
        let indexPath = NSIndexPath(forRow: testIndex, inSection: groupIndex)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        if let cell = cell {
            //cell.accessoryView
        }
    }
    
    private func markTestFailed(groupIndex groupIndex: Int, testIndex: Int, error: TestError?) {
    }
    
    private func updateCellWithResult(cell: UITableViewCell, result: TestResult?) {
        if let result = result {
            let image = imageForResult(result)
            let imageView = UIImageView(image: image)
            
            cell.accessoryView = imageView
        } else {
            cell.accessoryView = nil
        }
    }
    
    // MARK: - Preparing for segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let testDetailViewController = segue.destinationViewController as! TestDetailViewController
        
        testDetailViewController.test = testSession.testGroups[0].tests[0]
    }
}