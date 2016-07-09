import UIKit

import Foundation

class RunCircles : UIView{
    var counterColor: UIColor = UIColor.orangeColor()
   
    
    
    
    override func drawRect(rect: CGRect) {
        
        // 1
        let center = CGPoint(x:bounds.width*(1/3), y: bounds.height*(2/3))
        
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height)*(5/9)/2
        
        let arcWidth: CGFloat = 3
        
        var path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: CGFloat(0),
                                endAngle: CGFloat(M_PI * 2),
                                clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
    }
}