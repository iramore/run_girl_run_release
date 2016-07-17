import UIKit

import Foundation

@IBDesignable class RunCircles : UIView{
   
    @IBInspectable var bigCircleColor: UIColor = UIColor.blueColor()
    @IBInspectable var smallCircleColor: UIColor = UIColor.orangeColor()
    
    
   
    
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
        self.backgroundColor = UIColor.whiteColor()
        
    
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(0,  bounds.width - bounds.width*(5/6), bounds.width*(5/6), bounds.width*(5/6)))
        bigCircleColor.setFill()
        circlePath.fill()
        
        let circlePath2 = UIBezierPath(ovalInRect: CGRectMake(bounds.width*(1/2),  0, bounds.width*(1/2), bounds.width*(1/2)))
        smallCircleColor.setFill()
        circlePath2.fill()
        
        
    }
}