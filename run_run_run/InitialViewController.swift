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
            userData = UserData(daysOfWeek: days,
                completedTrainsDates: (userData?.completedTrainsDates)!)
        } else {
        userData = UserData(daysOfWeek: days)
        }
        saveUserData()
    }
    
    func increseNumberOfTrains(){
        if let _ = userData?.completedTrainsDates {
            userData = UserData(daysOfWeek: (userData?.daysOfWeek)!,
                completedTrainsDates: (userData?.completedTrainsDates)!)
        } else {
        userData = UserData(daysOfWeek: (userData?.daysOfWeek)!)
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
        shareData.userData = UserData(daysOfWeek: [0,2,4], completedTrainsDates: [NSDate(dateString:"2016-08-06"),NSDate(dateString:"2016-08-08"),NSDate(dateString:"2016-08-19"),NSDate(dateString:"2016-08-09"),NSDate(dateString:"2016-08-22"), NSDate(dateString:"2016-08-28")])
        shareData.saveUserData()
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .TranslateMid
        transition.stiffness = 0.6
        
        
        let image1  = UIImage(named: "plan3") as UIImage?
        
        let frame1 = CGRectMake(self.view.bounds.width/2 - (image1?.size.width)! - 5,self.view.bounds.height*2/3 - (image1?.size.height)!, (image1?.size.width)! , (image1?.size.height)!)
        
        
        let planButton = MenuButton(path: firstButtonBezier(), frame: frame1, image: "plan3")
        planButton.addTarget(self, action: #selector(didPressTriangle) , forControlEvents: UIControlEvents.TouchUpInside)
        
        let image2  = UIImage(named: "run-bb") as UIImage?
        
        let frame2 = CGRectMake(self.view.bounds.width/2 + 5,self.view.bounds.height*2/3 - (image2?.size.height)!, (image2?.size.width)! , (image2?.size.height)!)
        
        
        let runButton = MenuButton(path: secondButtonBezier(), frame: frame2, image: "run-bb")
        runButton.addTarget(self, action: #selector(didPressSquare), forControlEvents: UIControlEvents.TouchUpInside)
        
        let image3  = UIImage(named: "cal-but") as UIImage?
        
        let frame3 = CGRectMake(self.view.bounds.width/2 - (image3?.size.width)!/2 ,self.view.bounds.height*2/3 - (image3?.size.height)!/2 + 7, (image3?.size.width)! , (image3?.size.height)!)
        
        
        let trackButton = MenuButton(path: thirdButtonBezier(), frame: frame3, image: "cal-but")
        trackButton.addTarget(self, action: #selector(didPressPentagon), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(planButton)
        self.view.addSubview(runButton)
        self.view.addSubview(trackButton)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
        if let vc = vc as? CalViewController{
            vc.transition = transition
        }
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    
    func didPressTriangle(sender: AnyObject?) {
        transition.edge = .Left
        transition.startingPoint = sender!.center
        performSegueWithIdentifier("plan", sender: self)
    }
    
    func didPressSquare(sender: AnyObject?) {
        transition.edge = .Right
        transition.startingPoint = sender!.center
        performSegueWithIdentifier("run", sender: self)
    }
    
    func didPressPentagon(sender: AnyObject?) {
        transition.edge = .Bottom
        transition.startingPoint = sender!.center
        performSegueWithIdentifier("option", sender: self)
//        transition.edge = .Bottom
//        transition.startingPoint = sender!.center
//        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("calendarControl") as! CalViewController
//        modalViewController.transition = transition
//        presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func firstButtonBezier() -> UIBezierPath {
        let ovalPath = UIBezierPath(ovalInRect: CGRect(x: 71, y: 38, width: 45, height: 41))
        UIColor.grayColor().setFill()
        ovalPath.fill()
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 126.84, y: 126.82))
        bezierPath.addLineToPoint(CGPoint(x: 16.76, y: 189.82))
        bezierPath.addLineToPoint(CGPoint(x: 17.04, y: 190.3))
        bezierPath.addCurveToPoint(CGPoint(x: 63.46, y: 17.06), controlPoint1: CGPoint(x: -17.98, y: 129.65), controlPoint2: CGPoint(x: 2.8, y: 52.08))
        bezierPath.addLineToPoint(CGPoint(x: 63.05, y: 17.31))
        bezierPath.addCurveToPoint(CGPoint(x: 125.5, y: -0), controlPoint1: CGPoint(x: 81.91, y: 5.98), controlPoint2: CGPoint(x: 103.5, y: -0))
        bezierPath.addLineToPoint(CGPoint(x: 126.84, y: 126.82))
        bezierPath.closePath()
        bezierPath.miterLimit = 4
        bezierPath.fill()
        
        return bezierPath
    }
    
    
    func secondButtonBezier() -> UIBezierPath {
        
        let fillColor = UIColor(red: 0.939, green: 0.847, blue: 0.502, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: 126.82))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: -0.02))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: -0.02))
        bezierPath.addCurveToPoint(CGPoint(x: 126.82, y: 126.8), controlPoint1: CGPoint(x: 70.04, y: -0.02), controlPoint2: CGPoint(x: 126.82, y: 56.76))
        bezierPath.addLineToPoint(CGPoint(x: 126.81, y: 126.18))
        bezierPath.addCurveToPoint(CGPoint(x: 110.58, y: 188.92), controlPoint1: CGPoint(x: 127.19, y: 148.18), controlPoint2: CGPoint(x: 121.59, y: 169.87))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 126.82))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        return bezierPath
    }
    
    
    func thirdButtonBezier() -> UIBezierPath {
        
        
        let fillColor = UIColor(red: 0.708, green: 0.826, blue: 0.887, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 108.67, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 218.67, y: 63.14))
        bezierPath.addLineToPoint(CGPoint(x: 218.52, y: 63.41))
        bezierPath.addCurveToPoint(CGPoint(x: 45.28, y: 109.83), controlPoint1: CGPoint(x: 183.49, y: 124.07), controlPoint2: CGPoint(x: 105.93, y: 144.85))
        bezierPath.addLineToPoint(CGPoint(x: 45.83, y: 110.14))
        bezierPath.addCurveToPoint(CGPoint(x: -0.39, y: 64.72), controlPoint1: CGPoint(x: 26.59, y: 99.48), controlPoint2: CGPoint(x: 10.61, y: 83.77))
        bezierPath.addLineToPoint(CGPoint(x: 108.67, y: 0))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        return bezierPath
    }

    
}
