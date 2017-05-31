import UIKit
import ElasticTransition

enum LeftMenuType{
    case mySegment(values: [String], selected: [Int], name: String, label: String)
    case `switch`(name:String, on:Bool, onChange:(_ on:Bool, _ sender: UISwitch)->Void)
}


class MySegmentCell: UITableViewCell {
    
    @IBOutlet weak var segmentControl: SegmentControl!
    @IBOutlet weak var label: UILabel!
}

class SwitchCell:UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var control: UISwitch!
    var onChange:((_ on:Bool,_ sender: UISwitch)->Void)?
    @IBAction func switchChanged(_ sender: UISwitch) {
        onChange?(sender.isOn, sender)
    }
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
        var calendar = Calendar.current
        var days: [String]
        calendar.locale = Locale(identifier: Locale.current.languageCode!)
        if calendar.firstWeekday==2{
            days = [NSLocalizedString("options.days.mn", comment: ""), NSLocalizedString("options.days.tu", comment: ""), NSLocalizedString("options.days.wd", comment: ""), NSLocalizedString("options.days.th", comment: ""), NSLocalizedString("options.days.fr", comment: ""), NSLocalizedString("options.days.sa", comment: ""),NSLocalizedString("options.days.su", comment: "")]
        } else{
            days = [NSLocalizedString("options.days.su", comment: ""),NSLocalizedString("options.days.mn", comment: ""), NSLocalizedString("options.days.tu", comment: ""), NSLocalizedString("options.days.wd", comment: ""), NSLocalizedString("options.days.th", comment: ""), NSLocalizedString("options.days.fr", comment: ""), NSLocalizedString("options.days.sa", comment: "")]
        }
        menu.append(.switch(name: NSLocalizedString("optionsPage.notificationSwitch.label", comment: ""), on:  UserDefaults.standard.bool(forKey: "notifyMe")&&self.isNotificationsAvailable(), onChange: { on,sender in
            if on {
                if !self.isNotificationsAvailable() && !UserDefaults.standard.bool(forKey: "askedAboutNotif"){
                    self.registerForNotifications(types:  [.alert, .badge, .sound])
                    UserDefaults.standard.set(true, forKey: "notifyMe")
                    UserDefaults.standard.set(true, forKey: "askedAboutNotif")
                    self.sendNextTrainNotifications()
                } else{
                    if self.isNotificationsAvailable() {
                        UserDefaults.standard.set(true, forKey: "notifyMe")
                        self.sendNextTrainNotifications()
                    } else {
                        self.showNotifNotAlowededAlert()
                        sender.isOn = false
                    }
                }
                
            }
            else {
                UserDefaults.standard.set(false, forKey: "notifyMe")
                self.deleteNextTrainNotifications()
            }
            
        }))
        menu.append(.mySegment(values: ["1", "2", "3", "4", "5"],selected: [(self.shareData.loadUserData()?.daysOfWeek.count)!-1], name: "Number", label: NSLocalizedString("optionsPage.trainingsPerWeek", comment: "")))
        menu.append(.mySegment(values: days,selected: (self.shareData.loadUserData()?.daysOfWeek)!,  name: "Days", label: NSLocalizedString("optionsPage.daysOfTheWeek", comment: "")))
        
        
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
            
            let indexPath = IndexPath(row: 2, section: 0)
            let weekSegmentCell = tableView.cellForRow(at: indexPath)  as! MySegmentCell
            weekSegmentCell.segmentControl.selectedIndexes = newSelected
            self.shareData.saveUserDataOption(newSelected)
            if UserDefaults.standard.bool(forKey: "notifyMe")&&self.isNotificationsAvailable() {
                deleteNextTrainNotifications()
                sendNextTrainNotifications()
            }
            
        case "Days":
            var selIndexes = control.selectedIndexes
            if (selIndexes.contains(value) && selIndexes.count>1){
                selIndexes.remove(at: selIndexes.index(of: value)!)
            } else if(!selIndexes.contains(value) && selIndexes.count<5){
                selIndexes += [value]
            }
            control.selectedIndexes = selIndexes
            
            let indexPath = IndexPath(row: 1, section: 0)
            let weekSegmentCell = tableView.cellForRow(at: indexPath)  as! MySegmentCell
            weekSegmentCell.segmentControl.selectedIndexes = [selIndexes.count-1]
            self.shareData.saveUserDataOption(selIndexes)
            if UserDefaults.standard.bool(forKey: "notifyMe")&&self.isNotificationsAvailable() {
                deleteNextTrainNotifications()
                sendNextTrainNotifications()
            }
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
        case .switch(let name, let on, let onChange):
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "switch", for: indexPath) as! SwitchCell
            switchCell.nameLabel.font = UIFont(name: "Arial-Black", size: 11.0)
            switchCell.onChange = onChange
            switchCell.nameLabel.text = name
            switchCell.control.isOn = on
            cell = switchCell
            
        case .mySegment(let values, let selected, let name ,let label):
            let mySegment = tableView.dequeueReusableCell(withIdentifier: "my_segment", for: indexPath) as! MySegmentCell
            mySegment.segmentControl.buttonTitles = values
            mySegment.segmentControl.delegate = self
            mySegment.segmentControl.selectedIndexes = selected
            mySegment.segmentControl.name = name
            mySegment.label.text = label
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

extension OptionsViewController{
    
    func showNotifNotAlowededAlert(){
        let alert = UIAlertController(title: NSLocalizedString("optionsPage.notificationNotAlloweded.title", comment: ""), message: NSLocalizedString("optionsPage.notificationNotAlloweded.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendNextTrainNotifications(){
        
        var today = Date()
        var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: today)
        var ind = (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!
        while(ind != 27){
            today = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: today)
            if (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
                let elapsed = today.timeIntervalSince(Date())
                scheduleNotification(identifier: "run-new-train-\(ind)", title: NSLocalizedString("newTrainNotif.title", comment: "") ,body: NSLocalizedString("newTrainNotif.body", comment: ""), timeInterval: TimeInterval(elapsed))
                ind += 1
            }
        }
    }
    
    func deleteNextTrainNotifications(){
        let notificationArr:NSArray?  =  UIApplication.shared.scheduledLocalNotifications as NSArray?
        notificationArr!.enumerateObjects({ object, index, stop in
            
            let notification = object as! UILocalNotification;
            let userInfo = notification.userInfo! as NSDictionary
            let notificationID = userInfo["notificationID"] as! String
            
            if(notificationID.hasPrefix("run-new-train-")){
                
                
                UIApplication.shared.cancelLocalNotification(notification)
                
            }
        })
    }
    
    func scheduleNotification(identifier: String, title: String, body: String, timeInterval: TimeInterval, repeats: Bool = false) {
        
        let notification = UILocalNotification()
        notification.alertBody = "\(title)\n\(body)"
        notification.fireDate = Date(timeIntervalSinceNow: timeInterval)
        notification.userInfo = ["notificationID" : identifier]
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    func isNotificationsAvailable() -> Bool{
        return UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
    }
    func registerForNotifications(types: UIUserNotificationType) {
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
    }
    
    
}
