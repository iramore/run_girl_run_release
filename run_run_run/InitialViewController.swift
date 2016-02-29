import UIKit
import ElasticTransition

class InitialViewController: UIViewController {
    
    
    var transition = ElasticTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customization
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
//    
//    @IBAction func navigationBtnTouched(sender: AnyObject) {
//        transition.edge = .Right
//        transition.startingPoint = sender.center
//        performSegueWithIdentifier("run", sender: self)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
//        if segue.identifier == "navigation"{
//            if let vc = vc as? UINavigationController{
//                vc.delegate = transition
//            }
//        }else{
            if let vc = vc as? CalViewController{
                vc.transition = transition
            }
       // }
    }
    
}
