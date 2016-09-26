import UIKit
import ElasticTransition

enum LeftMenuType{
    case mySegment(values: [String], selected: [Int], name: String)
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
    menu.append(.mySegment(values: ["1", "2", "3", "4", "5"],selected: [(self.shareData.loadUserData()?.daysOfWeek.count)!-1], name: "Number"))
    menu.append(.mySegment(values: ["M", "Tu", "W", "Th", "F", "Sa","Su"],selected: (self.shareData.loadUserData()?.daysOfWeek)!,  name: "Days"))
    
    
    for i in 0..<menu.count{
      contentLength += self.tableView(self.tableView, heightForRowAt: IndexPath(row:i, section:0))
    }
    tableView.reloadData()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
    
    func segmentChanged(_ control: SegmentControl, value: Int) {
        switch control.name{
            case "Number":
                control.selectedIndexes = [value]
                let newSelected = Array(self.initialSelectectionForDays[0...value])
                
                let indexPath = IndexPath(row: 1, section: 0)
                let weekSegmentCell = tableView.cellForRow(at: indexPath)  as! MySegmentCell
                weekSegmentCell.segmentControl.selectedIndexes = newSelected
            self.shareData.saveUserDataOption(newSelected)

            case "Days":
                var selIndexes = control.selectedIndexes
                if (selIndexes.contains(value) && selIndexes.count>1){
                    selIndexes.remove(at: selIndexes.index(of: value)!)
                } else if(selIndexes.count<5){
                    selIndexes += [value]
                }
                control.selectedIndexes = selIndexes
                
                let indexPath = IndexPath(row: 0, section: 0)
                let weekSegmentCell = tableView.cellForRow(at: indexPath)  as! MySegmentCell
                weekSegmentCell.segmentControl.selectedIndexes = [selIndexes.count-1]
                self.shareData.saveUserDataOption(selIndexes)
            default:
                print("Default")
        }
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell
    switch menu[(indexPath as NSIndexPath).item]{
    case .mySegment(let values, let selected, let name):
        let mySegment = tableView.dequeueReusableCell(withIdentifier: "my_segment", for: indexPath) as! MySegmentCell
        mySegment.segmentControl.buttonTitles = values
        mySegment.segmentControl.delegate = self
        mySegment.segmentControl.selectedIndexes = selected
        mySegment.segmentControl.name = name
        cell = mySegment
    }
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menu.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 72
  }
}
