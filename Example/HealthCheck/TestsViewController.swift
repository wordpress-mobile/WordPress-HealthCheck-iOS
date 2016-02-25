import Foundation
import HealthCheck
import UIKit

class ExampleTest : Test {
    
    func name() -> String {
        return "First test"
    }
    
    func description() -> String {
        return "First test description"
    }
    
    func run(onCompletion onCompletion: TestCompletionHandler)
    {
        sleep(1)
        onCompletion(success: true, error: nil)
    }
}

class TestsViewController : UITableViewController {
    
    private var testGroups = [TestGroup]()
    
    /// The login info this VC will use for its tests.
    ///
    /// - Note: Must be set by whoever is creating this VC.
    ///
    var loginInfo: LoginInfo!
    
    override func viewDidLoad() {
        let firstTest = ExampleTest()
        let tests: [Test] = [firstTest]
        let demoTestGroup = TestGroup(name: "XMLRPC", tests: tests)
        
        testGroups.append(demoTestGroup)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return testGroups.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testGroups[section].tests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestsViewControllerCell", forIndexPath:  indexPath)
        
        let groupIndex = indexPath.section
        let testIndex = indexPath.row
        
        let test = testGroups[groupIndex].tests[testIndex]
        
        cell.textLabel?.text = test.name()
        cell.detailTextLabel?.text = test.description()
        cell.accessoryType = .None
        cell.accessoryView = nil
        
        return cell
    }
}