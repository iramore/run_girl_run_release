
import UIKit
import ElasticTransition
import ActionSheetPicker_3_0
import EZAlertController

enum LeftMenuType{
    case Switch(name:String, on:Bool, onChange:(on:Bool)->Void)
    case Slider(name:String, value:Float, onChange:(value:Float)->Void)
    case Segment(name:String, values:[Any], selected:Int, onChange:(value:Any)->Void)
    case Button(name:String)
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

class ButtonCell:UITableViewCell{
    @IBOutlet weak var button: UIButton!
}

class OptionsViewController: UIViewController, ElasticMenuTransitionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let shareData = ShareData.sharedInstance
    
    var daysOfWeekArray:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var arrayForDayChooser = Array<Array<String>>()
    
    var initialSelectectionForDays: [Int] = [0,2,4,5,6]
    
    var contentLength:CGFloat = 0
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    
    var menu:[LeftMenuType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.append(.Button(name: self.createNumberOfDaysButtonNameInitial()))
        
        menu.append(.Button(name: self.createDaysOfWeekButtonNameInitial()))
        
        for i in 0..<menu.count{
            contentLength += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow:i, inSection:0))
        }
        self.changeNumberOfDaysPickerName((shareData.userData?.daysOfWeek.count)!-1)
        tableView.reloadData()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        switch sender.tag{
        case 0:
            ActionSheetStringPicker.showPickerWithTitle("Trains per week", rows: ["1 day a week", "2 days a week", "3 days a week", "4 days a week", "5 days a week"], initialSelection: (shareData.userData?.daysOfWeek.count)!-1, doneBlock: {
                picker, value, index in
                print("value = \(value)")
                print("index = \(index)")
                print("picker = \(picker)")
                self.arrayForDayChooser.removeAll()
                self.changeNumberOfDaysPickerName(value)
                self.menu[0] = .Button(name: index as! String)
                self.shareData.saveUserDataOption(Array(self.initialSelectectionForDays[0...value]))
                let secondButton = self.createDaysOfWeekButtonNameInitial()
                self.menu[1] = .Button(name: secondButton )
                self.tableView.reloadData()
                return
                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        case 1:
            ActionSheetMultipleStringPicker.showPickerWithTitle("Days of the week", rows: arrayForDayChooser, initialSelection: initialSelectectionForDays, doneBlock: {
                picker, values, indexes in
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                let duplicates = Array(Set((values as! [Int]).filter({ (i: Int) in (values as! [Int]).filter({ $0 == i }).count > 1})))
                if(duplicates.count > 0 ){
                    let alertController = UIAlertController(title: "", message:
                        "Choose different days, please", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    self.shareData.saveUserDataOption(values as! [Int])
                    self.menu[1] = .Button(name: self.createDaysOfWeekButtonNameInitial())
                    self.tableView.reloadData()
                }
                return
                }, cancelBlock: { ActionMultipleStringCancelBlock in return }, origin: sender)
        default:
            break
        }
    }
    func createNumberOfDaysButtonNameInitial() ->String{
        switch (shareData.userData?.daysOfWeek.count)! {
        case 1:
            return "1 day a week"
        default:
            return "\((shareData.userData?.daysOfWeek.count)!) days a week"
        }
    }
    func createSecondButtonTitle(dayIndex: Int) -> String{
        var result = ""
        for var index = 0; index <= dayIndex; ++index {
            result+=" "+daysOfWeekArray[initialSelectectionForDays[index]]
        }
        return result
    }
    func createDaysOfWeekButtonNameInitial() ->String{
        var result: String = ""
        for var i = 0; i<(shareData.userData?.daysOfWeek.count)!; ++i{
            result += daysOfWeekArray[(shareData.userData?.daysOfWeek[i])!]+" "
        }
        return result
    }
    func changeNumberOfDaysPickerName(numberOfTheDay : Int){
        for _ in 0...numberOfTheDay {
            self.arrayForDayChooser.append(daysOfWeekArray)
        }
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
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
            
        case .Button(let name):
            let buttonCell  = tableView.dequeueReusableCellWithIdentifier("button", forIndexPath: indexPath) as! ButtonCell
            buttonCell.button.setTitle(name, forState: .Normal)
            buttonCell.button.tag = indexPath.row;
            cell = buttonCell
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
        default:
            return 72
        }
    }
    
}