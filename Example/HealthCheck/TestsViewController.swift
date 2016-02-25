import Foundation
import HealthCheck
import UIKit

class ExampleTest : Test {
    
    var result: TestResult? = nil
    
    func name() -> String {
        return "First test"
    }
    
    func description() -> String {
        return "First test description"
    }
    
    func run(onComplete: TestCompletionHandler)
    {
        sleep(1)
        onComplete(test: self, success: true)
    }
}

class TestsViewController : UITableViewController {
    
    private var testGroups = [TestGroup]()
    
    override func viewDidLoad() {
        let firstTest = ExampleTest()
        let tests: [Test] = [firstTest]
        let demoTestGroup = TestGroup(name: "XMLRPC", tests: tests)
        
        testGroups.append(demoTestGroup)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return testGroups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestsViewControllerCell", forIndexPath:  indexPath)
        
        let groupIndex = indexPath.section
        let testIndex = indexPath.row
        
        let test = testGroups[groupIndex].tests[testIndex]
        
        cell.textLabel?.text = test.name()
        cell.detailTextLabel?.text = test.description()
        cell.accessoryType = .None
        
        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String] {
        var titles = [String]()
        
        for testGroup in testGroups {
            titles.append(testGroup.name)
        }
        
        return titles
    }
}