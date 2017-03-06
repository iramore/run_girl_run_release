import UIKit
import ElasticTransition

class ShareData {
    
    class var sharedInstance: ShareData {
        struct Static {
            static let instance: ShareData = ShareData()
        }
        return Static.instance
    }
    
    
    var userData: UserData?
    
    func loadUserData() -> UserData? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserData.ArchiveURL.path) as? UserData
    }
    
    func saveUserData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData!, toFile: UserData.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save user data...")
        }
    }
    
    func saveUserDataOption(_ days: [Int]){
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

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}

class InitialViewController: UIViewController {
    @IBOutlet weak var infoButton: UIButton!
    
    
    var transition = ElasticTransition()
    var userData: UserData?
    let shareData = ShareData.sharedInstance
    let lgr = UIScreenEdgePanGestureRecognizer()
    let rgr = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current
        let language = locale.languageCode
        //let currencyCode = locale.currencyCode
        
        shareData.userData = UserData(daysOfWeek: [1,3,5], completedTrainsDates: [Date(dateString:"2016-08-06")])
        shareData.saveUserData()
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .translateMid
        transition.stiffness = 0.9
        
        lgr.addTarget(self, action: #selector(InitialViewController.handlePan(_:)))
        rgr.addTarget(self, action: #selector(InitialViewController.handleRightPan(_:)))
        lgr.edges = .left
        rgr.edges = .right
        view.addGestureRecognizer(lgr)
        view.addGestureRecognizer(rgr)
        
        
        let image1  = UIImage(named: "plan3") as UIImage?
        
        let frame1 = CGRect(x: self.view.bounds.width/2 - (image1?.size.width)! - 5,y: self.view.bounds.height*2/3 - (image1?.size.height)!, width: (image1?.size.width)! , height: (image1?.size.height)!)
        
        
        let planButton = MenuButton(path: firstButtonBezier(), frame: frame1, image: "plan3")
        planButton.addTarget(self, action: #selector(didPressTriangle) , for: UIControlEvents.touchUpInside)
        
        let image2  = UIImage(named: "run-bb") as UIImage?
        
        let frame2 = CGRect(x: self.view.bounds.width/2 + 5,y: self.view.bounds.height*2/3 - (image2?.size.height)!, width: (image2?.size.width)! , height: (image2?.size.height)!)
        
        
        let runButton = MenuButton(path: secondButtonBezier(), frame: frame2, image: "run-bb")
        runButton.addTarget(self, action: #selector(didPressSquare), for: UIControlEvents.touchUpInside)
        
        let image3  = UIImage(named: "cal-but") as UIImage?
        
        let frame3 = CGRect(x: self.view.bounds.width/2 - (image3?.size.width)!/2 ,y: self.view.bounds.height*2/3 - (image3?.size.height)!/2 + 7, width: (image3?.size.width)! , height: (image3?.size.height)!)
        
        
        let trackButton = MenuButton(path: thirdButtonBezier(), frame: frame3, image: "cal-but")
        trackButton.addTarget(self, action: #selector(didPressPentagon), for: UIControlEvents.touchUpInside)
        
        infoButton.addTarget(self, action: #selector(didPressInfo), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(planButton)
        self.view.addSubview(runButton)
        self.view.addSubview(trackButton)
        
    }
    
    func handlePan(_ pan:UIPanGestureRecognizer){
        if pan.state == .began{
            transition.edge = .left
            transition.startInteractiveTransition(self, segueIdentifier: "plan", gestureRecognizer: pan)
        }else{
            _ = transition.updateInteractiveTransition(gestureRecognizer: pan)
        }
    }
    
    func handleRightPan(_ pan:UIPanGestureRecognizer){
        if pan.state == .began{
            transition.edge = .right
            transition.startInteractiveTransition(self, segueIdentifier: "run", gestureRecognizer: pan)
        }else{
            _ = transition.updateInteractiveTransition(gestureRecognizer: pan)
        }
    }

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let vc = segue.destination
            vc.transitioningDelegate = transition
            vc.modalPresentationStyle = .custom
            if let vc = vc as? CalViewController{
                vc.transition = transition
            }
        
    }
    
    func didPressInfo(_ sender: AnyObject?){
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "modalInfo") as! InfoModalViewController
        modalViewController.modalTransition.edge = .top
        present(modalViewController, animated: true, completion: nil)
    }
    
    func didPressTriangle(_ sender: AnyObject?) {
//        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "planModal") as! PlanViewController
//        modalViewController.modalTransition.edge = .left
//        present(modalViewController, animated: true, completion: nil)
        transition.edge = .left
        transition.startingPoint = sender!.center
        performSegue(withIdentifier: "plan", sender: self)
    }
    
    func didPressSquare(_ sender: AnyObject?) {
        transition.edge = .right
        transition.startingPoint = sender!.center
        performSegue(withIdentifier: "run", sender: self)
    }
    
    func didPressPentagon(_ sender: AnyObject?) {
        transition.edge = .bottom
        transition.startingPoint = sender!.center
        performSegue(withIdentifier: "option", sender: self)
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
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 71, y: 38, width: 45, height: 41))
        UIColor.gray.setFill()
        ovalPath.fill()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 126.84, y: 126.82))
        bezierPath.addLine(to: CGPoint(x: 16.76, y: 189.82))
        bezierPath.addLine(to: CGPoint(x: 17.04, y: 190.3))
        bezierPath.addCurve(to: CGPoint(x: 63.46, y: 17.06), controlPoint1: CGPoint(x: -17.98, y: 129.65), controlPoint2: CGPoint(x: 2.8, y: 52.08))
        bezierPath.addLine(to: CGPoint(x: 63.05, y: 17.31))
        bezierPath.addCurve(to: CGPoint(x: 125.5, y: -0), controlPoint1: CGPoint(x: 81.91, y: 5.98), controlPoint2: CGPoint(x: 103.5, y: -0))
        bezierPath.addLine(to: CGPoint(x: 126.84, y: 126.82))
        bezierPath.close()
        bezierPath.miterLimit = 4
        bezierPath.fill()
        
        return bezierPath
    }
    
    
    func secondButtonBezier() -> UIBezierPath {
        
        let fillColor = UIColor(red: 0.939, green: 0.847, blue: 0.502, alpha: 1.000)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 126.82))
        bezierPath.addLine(to: CGPoint(x: 0, y: -0.02))
        bezierPath.addLine(to: CGPoint(x: 0, y: -0.02))
        bezierPath.addCurve(to: CGPoint(x: 126.82, y: 126.8), controlPoint1: CGPoint(x: 70.04, y: -0.02), controlPoint2: CGPoint(x: 126.82, y: 56.76))
        bezierPath.addLine(to: CGPoint(x: 126.81, y: 126.18))
        bezierPath.addCurve(to: CGPoint(x: 110.58, y: 188.92), controlPoint1: CGPoint(x: 127.19, y: 148.18), controlPoint2: CGPoint(x: 121.59, y: 169.87))
        bezierPath.addLine(to: CGPoint(x: 0, y: 126.82))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        return bezierPath
    }
    
    
    func thirdButtonBezier() -> UIBezierPath {
        
        
        let fillColor = UIColor(red: 0.708, green: 0.826, blue: 0.887, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 108.67, y: 0))
        bezierPath.addLine(to: CGPoint(x: 218.67, y: 63.14))
        bezierPath.addLine(to: CGPoint(x: 218.52, y: 63.41))
        bezierPath.addCurve(to: CGPoint(x: 45.28, y: 109.83), controlPoint1: CGPoint(x: 183.49, y: 124.07), controlPoint2: CGPoint(x: 105.93, y: 144.85))
        bezierPath.addLine(to: CGPoint(x: 45.83, y: 110.14))
        bezierPath.addCurve(to: CGPoint(x: -0.39, y: 64.72), controlPoint1: CGPoint(x: 26.59, y: 99.48), controlPoint2: CGPoint(x: 10.61, y: 83.77))
        bezierPath.addLine(to: CGPoint(x: 108.67, y: 0))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        fillColor.setFill()
        bezierPath.fill()
        
        return bezierPath
    }
    
    
}
