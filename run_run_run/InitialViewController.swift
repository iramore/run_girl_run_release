import UIKit
import ElasticTransition

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    var userData: UserData?
    
    func loadUserData() -> UserData? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserData.ArchiveURL.path!) as? UserData
    }
    
    func saveUserData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData!, toFile: UserData.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user data...")
        }
    }
    
    func saveUserDataOption(days: [Int]){
        if let _ = userData?.completedTrainsDates {
            userData = UserData(trainNumber: (userData?.trainNumber)!, daysOfWeek: days,
                completedTrainsDates: (userData?.completedTrainsDates)!)
        } else {
        userData = UserData(trainNumber: (userData?.trainNumber)!, daysOfWeek: days)
        }
        saveUserData()
    }
    
    func increseNumberOfTrains(){
        if let _ = userData?.completedTrainsDates {
            userData = UserData(trainNumber: ((userData?.trainNumber)!+1), daysOfWeek: (userData?.daysOfWeek)!,
                completedTrainsDates: (userData?.completedTrainsDates)!)
        } else {
        userData = UserData(trainNumber: ((userData?.trainNumber)!+1), daysOfWeek: (userData?.daysOfWeek)!)
        }
        saveUserData()
    }
    
}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        //dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

class InitialViewController: UIViewController {
    
    
    var transition = ElasticTransition()
    var userData: UserData?
    let shareData = ShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let userData = shareData.loadUserData() {
//           shareData.userData = userData
//        } else{
            shareData.userData = UserData(trainNumber: 1, daysOfWeek: [0,2,4], completedTrainsDates: [NSDate(dateString:"2016-03-06"),NSDate(dateString:"2016-03-08"),
                NSDate(dateString:"2016-03-09"), NSDate(dateString:"2016-03-12"),NSDate(dateString:"2016-03-13")])
            shareData.saveUserData()
 //       }
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .TranslateMid
        
    }
    
    
    @IBAction func codeBtnTouched(sender: AnyObject) {
        transition.edge = .Left
        transition.startingPoint = sender.center
        performSegueWithIdentifier("plan", sender: self)
    }
    
    @IBAction func optionBtnTouched(sender: AnyObject) {
        transition.edge = .Bottom
        transition.startingPoint = sender.center
        performSegueWithIdentifier("option", sender: self)
    }
    
    @IBAction func aboutBtnTouched(sender: AnyObject) {
        transition.edge = .Right
        transition.startingPoint = sender.center
        performSegueWithIdentifier("run", sender: self)
    }
    
   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
        if let vc = vc as? CalViewController{
            vc.transition = transition
        }
    }
    
}
