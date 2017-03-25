import UIKit
import BubbleTransition

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

class InitialViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var infoButton: UIButton!
    
    var userData: UserData?
    let shareData = ShareData.sharedInstance
    let transition = BubbleTransition()
    var planButton: UIButton?
    var runButton: UIButton?
    var trackButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareData.userData = UserData(daysOfWeek: [0,3,4], completedTrainsDates: [Date(dateString:"2017-03-16")])
        shareData.saveUserData()
        
        
        let image = UIImage(named: "circle")
        let imageView = UIImageView(image: image!)
        
        
        
        let imageLogo = UIImage(named: "logo")
        let imageViewLogo = UIImageView(image: imageLogo!)
        
        
        let image1  = UIImage(named: "plan3") as UIImage?
        let frame1 = CGRect(x: self.view.bounds.width/2 - (image1?.size.width)! - 5,y: self.view.bounds.height*2/3 - (image1?.size.height)!, width: (image1?.size.width)! , height: (image1?.size.height)!)
        
        planButton = MenuButton(path: newButton(), frame: frame1, image: "plan3")
        planButton?.addTarget(self, action: #selector(didPressTriangle) , for: UIControlEvents.touchUpInside)
        planButton?.backgroundColor = UIColor.white
        
        let image2  = UIImage(named: "run-bb") as UIImage?
        let frame2 = CGRect(x: self.view.bounds.width/2 + 5,y: self.view.bounds.height*2/3 - (image2?.size.height)!, width: (image2?.size.width)! , height: (image2?.size.height)!)
        
        
        runButton = MenuButton(path: runButtonBezier(), frame: frame2, image: "run-bb")
        runButton?.addTarget(self, action: #selector(didPressSquare), for: UIControlEvents.touchUpInside)
        runButton?.backgroundColor = UIColor.white
        
        let image3  = #imageLiteral(resourceName: "cal-but")
        let frame3 = CGRect(x: self.view.bounds.width/2 - (image3.size.width)/2 ,y: self.view.bounds.height*2/3 - (image3.size.height)/2 + 10, width: (image3.size.width) , height: (image3.size.height))
        
        trackButton = MenuButton(path: trackButtonBezier(), frame: frame3, image: "cal-but")
        trackButton?.addTarget(self, action: #selector(didPressPentagon), for: UIControlEvents.touchUpInside)
        trackButton?.backgroundColor = UIColor.white
        
        
        imageView.frame = CGRect(x: self.view.bounds.width/2 - (image1?.size.width)! - 15, y: self.view.bounds.height*2/3 - (image1?.size.height)! - 14, width: (image?.size.width)!, height: (image?.size.height)!)
        imageViewLogo.frame = CGRect(x: 20, y: 50, width: self.view.bounds.width - 40, height: self.view.bounds.height/5 )
        //print(imageLogo?.size)
        
        self.view.addSubview(imageView)
        self.view.addSubview(imageViewLogo)

        self.view.addSubview(planButton!)
        self.view.addSubview(runButton!)
        self.view.addSubview(trackButton!)
        
    }
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        if presented is PlanViewController {
            transition.startingPoint = (planButton?.center)!
            transition.bubbleColor = (planButton?.backgroundColor!)!
        }
        if presented is RunController {
            transition.startingPoint = (runButton?.center)!
            transition.bubbleColor = (runButton?.backgroundColor!)!
        }
        
        if presented is CalViewController {
            transition.startingPoint = (trackButton?.center)!
            transition.bubbleColor = (trackButton?.backgroundColor!)!
        }
        if presented is InfoModalViewController {
            transition.startingPoint = (infoButton?.center)!
            transition.bubbleColor = (infoButton?.backgroundColor!)!
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        if dismissed is PlanViewController {
            transition.startingPoint = (planButton?.center)!
            transition.bubbleColor = (planButton?.backgroundColor!)!
        }
        if dismissed is RunController {
            transition.startingPoint = (runButton?.center)!
            transition.bubbleColor = (runButton?.backgroundColor!)!
        }
        
        if dismissed is CalViewController {
            transition.startingPoint = (trackButton?.center)!
            transition.bubbleColor = (trackButton?.backgroundColor!)!
        }
        if dismissed is InfoModalViewController {
            transition.startingPoint = (infoButton?.center)!
            transition.bubbleColor = (infoButton?.backgroundColor!)!
        }
        
        return transition
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    
    
    func didPressTriangle(_ sender: AnyObject?) {
        
        
        performSegue(withIdentifier: "plan", sender: self)
    }
    
    func didPressSquare(_ sender: AnyObject?) {
        
        performSegue(withIdentifier: "run", sender: self)
    }
    
    func didPressPentagon(_ sender: AnyObject?) {
        
        performSegue(withIdentifier: "option", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func firstButtonBezier() -> UIBezierPath {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 71, y: 38, width: 45, height: 41))
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
        return bezierPath
    }
    
    
    func secondButtonBezier() -> UIBezierPath {
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
        return bezierPath
    }
    
    
    func thirdButtonBezier() -> UIBezierPath {
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
        return bezierPath
    }*/
    
    
    func trackButtonBezier() -> UIBezierPath{
                let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 117, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 63.75))
        bezierPath.addLine(to: CGPoint(x: 0, y: 70.89))
        bezierPath.addLine(to: CGPoint(x: 0, y: 70.89))
        bezierPath.addCurve(to: CGPoint(x: 49.44, y: 117.54), controlPoint1: CGPoint(x: 12.42, y: 91.19), controlPoint2: CGPoint(x: 27.93, y: 105.82))
        bezierPath.addCurve(to: CGPoint(x: 233.98, y: 70.89), controlPoint1: CGPoint(x: 114.05, y: 152.74), controlPoint2: CGPoint(x: 196.67, y: 131.86))
        bezierPath.addLine(to: CGPoint(x: 233.98, y: 70.89))
        bezierPath.addLine(to: CGPoint(x: 233.98, y: 63.75))
        bezierPath.addLine(to: CGPoint(x: 117, y: 0))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        return bezierPath
    }
    func runButtonBezier() -> UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 134.5, y: 128.12))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 134.5, y: 57.37), controlPoint2: CGPoint(x: 74.24, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 135.94))
        bezierPath.addLine(to: CGPoint(x: 116.48, y: 200))
        bezierPath.addCurve(to: CGPoint(x: 134.48, y: 135.94), controlPoint1: CGPoint(x: 128.85, y: 179.59), controlPoint2: CGPoint(x: 134.48, y: 159.5))
        bezierPath.addCurve(to: CGPoint(x: 134.42, y: 132.19), controlPoint1: CGPoint(x: 134.48, y: 134.68), controlPoint2: CGPoint(x: 134.48, y: 133.43))
        bezierPath.addCurve(to: CGPoint(x: 134.5, y: 128.12), controlPoint1: CGPoint(x: 134.36, y: 130.95), controlPoint2: CGPoint(x: 134.5, y: 129.49))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        return bezierPath
    }
    
    
    
    func newButton()-> UIBezierPath{
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 128.11))
        bezierPath.addCurve(to: CGPoint(x: 0.06, y: 132.18), controlPoint1: CGPoint(x: 0, y: 129.48), controlPoint2: CGPoint(x: 0, y: 130.83))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 135.93), controlPoint1: CGPoint(x: 0.12, y: 133.53), controlPoint2: CGPoint(x: 0, y: 134.68))
        bezierPath.addCurve(to: CGPoint(x: 18, y: 199.99), controlPoint1: CGPoint(x: 0, y: 159.49), controlPoint2: CGPoint(x: 5.65, y: 179.58))
        bezierPath.addLine(to: CGPoint(x: 134.48, y: 135.93))
        bezierPath.addLine(to: CGPoint(x: 134.48, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 128.11), controlPoint1: CGPoint(x: 60.22, y: 0), controlPoint2: CGPoint(x: 0, y: 57.36))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        
        return bezierPath
        
    }
    
    
}
