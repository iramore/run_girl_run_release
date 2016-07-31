import UIKit
import ElasticTransition

enum LeftMenuType{
  case Switch(name:String, on:Bool, onChange:(on:Bool)->Void)
  case Slider(name:String, value:Float, onChange:(value:Float)->Void)
  case Segment(name:String, values:[Any], selected:Int, onChange:(value:Any)->Void)
    case WeekSegment(name:String)
    case NumericSegment(name:String)
    case MySegment(values: [String], selected: [Int], maxSelected: Int, name: String)
}
class SwitchCell:UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var control: UISwitch!
  var onChange:((on:Bool)->Void)?
  @IBAction func switchChanged(sender: UISwitch) {
    onChange?(on: sender.on)
  }
}
class SliderCell:UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  var onChange:((value:Float)->Void)?
  @IBAction func sliderChanged(sender: UISlider) {
    onChange?(value: sender.value)
  }
}
class SegmentCell:UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var segment: UISegmentedControl!
  
  var values:[Any] = []
  var onChange:((value:Any)->Void)?

  @IBAction func segmentChanged(sender: UISegmentedControl) {
    onChange?(value: values[sender.selectedSegmentIndex])
  }
}

class WeekSegmentCell:UITableViewCell{
    @IBOutlet weak var weekSegment: MWSegmentedControl!
    @IBOutlet weak var weekLabel: UILabel!
}
class NumericSegmentCell: UITableViewCell{
    @IBOutlet weak var numericSegment: MWSegmentedControl!
    @IBOutlet weak var numericLabel: UILabel!
}

class MySegmentCell: UITableViewCell {

    @IBOutlet weak var segmentControl: SegmentControl!
}
class OptionsViewController: UIViewController, ElasticMenuTransitionDelegate, MWSegmentedControlDelegate, SegmentControlDelegate {
  
  @IBOutlet weak var tableView: UITableView!
    
    let shareData = ShareData.sharedInstance
    
    var initialSelectectionForDays: [Int] = [0,2,3,5,6]
    var contentLength:CGFloat = 0
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
  
  var menu:[LeftMenuType] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("loaded \((self.shareData.loadUserData()?.daysOfWeek)!)")
//    menu.append(.NumericSegment(name: "Trainings per week"))
//    menu.append(.WeekSegment(name: "Days"))
    menu.append(.MySegment(values: ["1", "2", "3", "4", "5"],selected: [2],maxSelected: 1, name: "Number"))
    menu.append(.MySegment(values: ["M", "Tu", "W", "Th", "F", "Sa","Su"],selected: (self.shareData.loadUserData()?.daysOfWeek)!, maxSelected: 3, name: "Days"))
    
    
    for i in 0..<menu.count{
      contentLength += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow:i, inSection:0))
    }
    tableView.reloadData()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
//    func segmentDidChange(control: MWSegmentedControl, value: Int) {
//        switch control.name{
//        case "Numeric":
//            print("Numeric")
//            let newSelected = Array(self.initialSelectectionForDays[0...value-1])
//            print(newSelected)
//            self.shareData.saveUserDataOption(newSelected)
//            //self.menu[1] = .WeekSegment(name: "lala")
//            //tableView.reloadData()
//            let indexPath = NSIndexPath(forRow: 1, inSection: 0)
//            let weekSegmentCell = tableView.dequeueReusableCellWithIdentifier("week_segment", forIndexPath: indexPath) as! WeekSegmentCell
//            weekSegmentCell.weekSegment.selectedIndexes = newSelected
//            weekSegmentCell.weekSegment.selectedSegments = ["M", "Tu", "W"]
//           
//         //   self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
//        //tableView.reloadData()
//        case "Days":
//            print("Days")
//        default:
//            print("Default")
//        }
//    }
    
    func segmentChanged(control: SegmentControl, value: Int) {
        switch control.name{
            case "Number":
                control.selectedIndexes = [value]
                let newSelected = Array(self.initialSelectectionForDays[0...value])
                self.shareData.saveUserDataOption(newSelected)
                let indexPath = NSIndexPath(forRow: 1, inSection: 0)
                let weekSegmentCell = tableView.cellForRowAtIndexPath(indexPath)  as! MySegmentCell

                weekSegmentCell.segmentControl.selectedIndexes = newSelected

            case "Days":
                print("Days")
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
    case .Switch(let name, let on, let onChange):
      let switchCell = tableView.dequeueReusableCellWithIdentifier("switch", forIndexPath: indexPath) as! SwitchCell
      switchCell.onChange = onChange
      switchCell.nameLabel.text = name
      switchCell.control.on = on
      cell = switchCell
    case .Segment(let name, let values, let selected, let onChange):
      let segmentCell  = tableView.dequeueReusableCellWithIdentifier("segment", forIndexPath: indexPath) as! SegmentCell
      segmentCell.onChange = onChange
      segmentCell.nameLabel.text = name
      segmentCell.segment.removeAllSegments()
      segmentCell.values = values
      for v in values.reverse(){
        segmentCell.segment.insertSegmentWithTitle("\(v)", atIndex: 0, animated: false)
      }
      segmentCell.segment.selectedSegmentIndex = selected
      cell = segmentCell
    case .Slider(let name, let value, let onChange):
      let sliderCell  = tableView.dequeueReusableCellWithIdentifier("slider", forIndexPath: indexPath) as! SliderCell
      sliderCell.onChange = onChange
      sliderCell.nameLabel.text = name
      sliderCell.slider.maximumValue = 1.0
      sliderCell.slider.minimumValue = 0
      sliderCell.slider.value = value
      cell = sliderCell
    case .WeekSegment(let name):
        let weekSegmentCell = tableView.dequeueReusableCellWithIdentifier("week_segment", forIndexPath: indexPath) as! WeekSegmentCell
        weekSegmentCell.weekSegment.font = UIFont(name: "Pragmatica", size: 24)
        weekSegmentCell.weekSegment.name = "Days"
        weekSegmentCell.weekSegment.buttonTitles = ["M", "Tu", "W", "Th", "F", "Sa","Su"]
        print("==========")
        print(".WeekSegment \((self.shareData.loadUserData()?.daysOfWeek)!)")
        weekSegmentCell.weekSegment.selectedIndexes = (self.shareData.loadUserData()?.daysOfWeek)!
        print(".WeekSegment \(weekSegmentCell.weekSegment.selectedIndexes)")
        weekSegmentCell.weekSegment.allowMultipleSelection = true
        weekSegmentCell.weekSegment.delegate = self
        
        weekSegmentCell.weekLabel.text = name
        
        cell = weekSegmentCell
        
    case .NumericSegment(let name):
        let numericSegment = tableView.dequeueReusableCellWithIdentifier("numeric_segment", forIndexPath: indexPath) as! NumericSegmentCell
        numericSegment.numericSegment.font = UIFont(name: "Pragmatica", size: 24)
        numericSegment.numericSegment.name = "Numeric"
        numericSegment.numericSegment.buttonTitles = ["1", "2", "3", "4", "5"]
        numericSegment.numericSegment.selectedIndexes = [(self.shareData.loadUserData()?.daysOfWeek.count)!-1]
        numericSegment.numericSegment.allowMultipleSelection = false
        numericSegment.numericSegment.delegate = self
        numericSegment.numericLabel.text = name
        cell = numericSegment
        
    case .MySegment(let values, let selected, let maxSelected, let name):
        let mySegment = tableView.dequeueReusableCellWithIdentifier("my_segment", forIndexPath: indexPath) as! MySegmentCell
        mySegment.segmentControl.buttonTitles = values
        mySegment.segmentControl.delegate = self
        mySegment.segmentControl.selectedIndexes = selected
        mySegment.segmentControl.maxSelected = maxSelected
        mySegment.segmentControl.name = name
        cell = mySegment
    }
    return cell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menu.count
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch menu[indexPath.item]{
    case .Switch:
      return 54
    case .Slider:
      return 62
    case .WeekSegment:
        return 85
    case .NumericSegment:
        return 85
    default:
      return 72
    }
  }
}