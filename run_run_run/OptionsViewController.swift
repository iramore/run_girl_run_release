import UIKit
import ElasticTransition

enum LeftMenuType{
    case MySegment(values: [String], selected: [Int], name: String)
}


class MySegmentCell: UITableViewCell {

    @IBOutlet weak var segmentControl: SegmentControl!
}
class OptionsViewController: UIViewController, ElasticMenuTransitionDelegate, SegmentControlDelegate {
  
  @IBOutlet weak var tableView: UITableView!
    
    let shareData = ShareData.sharedInstance
    
    var initialSelectectionForDays: [Int] = [0,2,4,5,6]
    var contentLength:CGFloat = 0
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
  
  var menu:[LeftMenuType] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("loaded \((self.shareData.loadUserData()?.daysOfWeek)!)")
    menu.append(.MySegment(values: ["1", "2", "3", "4", "5"],selected: [(self.shareData.loadUserData()?.daysOfWeek.count)!-1], name: "Number"))
    menu.append(.MySegment(values: ["M", "Tu", "W", "Th", "F", "Sa","Su"],selected: (self.shareData.loadUserData()?.daysOfWeek)!,  name: "Days"))
    
    
    for i in 0..<menu.count{
      contentLength += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow:i, inSection:0))
    }
    tableView.reloadData()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
    
    func segmentChanged(control: SegmentControl, value: Int) {
        switch control.name{
            case "Number":
                control.selectedIndexes = [value]
                let newSelected = Array(self.initialSelectectionForDays[0...value])
                
                let indexPath = NSIndexPath(forRow: 1, inSection: 0)
                let weekSegmentCell = tableView.cellForRowAtIndexPath(indexPath)  as! MySegmentCell
                weekSegmentCell.segmentControl.selectedIndexes = newSelected
            self.shareData.saveUserDataOption(newSelected)

            case "Days":
                var selIndexes = control.selectedIndexes
                if (selIndexes.contains(value) && selIndexes.count>1){
                    selIndexes.removeAtIndex(selIndexes.indexOf(value)!)
                } else if(selIndexes.count<5){
                    selIndexes += [value]
                }
                control.selectedIndexes = selIndexes
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                let weekSegmentCell = tableView.cellForRowAtIndexPath(indexPath)  as! MySegmentCell
                weekSegmentCell.segmentControl.selectedIndexes = [selIndexes.count-1]
                self.shareData.saveUserDataOption(selIndexes)
            default:
                print("Default")
        }
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:UITableViewCell
    switch menu[indexPath.item]{
    case .MySegment(let values, let selected, let name):
        let mySegment = tableView.dequeueReusableCellWithIdentifier("my_segment", forIndexPath: indexPath) as! MySegmentCell
        mySegment.segmentControl.buttonTitles = values
        mySegment.segmentControl.delegate = self
        mySegment.segmentControl.selectedIndexes = selected
        mySegment.segmentControl.name = name
        cell = mySegment
    }
    return cell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menu.count
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return 72
  }
}