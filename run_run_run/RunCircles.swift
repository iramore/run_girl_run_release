import UIKit

import Foundation

@IBDesignable class RunCircles : UIView{
   
    @IBInspectable var bigCircleColor: UIColor = UIColor.blueColor()
    @IBInspectable var smallCircleColor: UIColor = UIColor.orangeColor()
    @IBInspectable var outlineColorSmall: UIColor = UIColor.blueColor()
    @IBInspectable var outlineColorBig: UIColor = UIColor.blueColor()
    var arcWidthSmall: CGFloat = 27.0
    var maxValueSmall:Int = 0
    var counterSmall: Int = 0 {
        didSet {
            if counterSmall <=  maxValueSmall {
                setNeedsDisplay()
            }
        }
    }
    var arcWidthBig: CGFloat = 30.0
    var maxValueBig:Int = 0
    var counterBig: Int = 0 {
        didSet {
            if counterBig <=  maxValueBig {
                setNeedsDisplay()
            }
        }
    }


    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(bounds.width - bounds.width*(5/6)+3.75,  3.75, bounds.width*(5/6)-7.5, bounds.width*(5/6)-7.5))
       
        bigCircleColor.setFill()
        
        circlePath.fill()
        
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = π / 2
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        let centerBig = CGPoint(x:bounds.width - bounds.width*5/12, y: bounds.height*5/12)

        let arcLengthPerGlassBig = angleDifference / CGFloat(maxValueBig)
        
        let outlineEndAngleBig = arcLengthPerGlassBig * CGFloat(counterBig) + startAngle
        
        let outlinePathBig = UIBezierPath(arcCenter: centerBig,
                                          radius: bounds.width*5/12 - 7.5,
                                          startAngle: startAngle,
                                          endAngle: outlineEndAngleBig,
                                          clockwise: true)
        
        outlineColorBig.setStroke()
        outlinePathBig.lineWidth = 15.0
        outlinePathBig.stroke()

        
        let circlePath2 = UIBezierPath(ovalInRect: CGRectMake(2.5,  bounds.width*(1/2)+2.5, bounds.width*(1/2)-5, bounds.width*(1/2)-5))
        let trColor = smallCircleColor.colorWithAlphaComponent(0.7)
        trColor.setFill()
        circlePath2.fill()
        
        let center = CGPoint(x:bounds.width/4, y: bounds.height*3/4)
        let arcLengthPerGlass = angleDifference / CGFloat(maxValueSmall)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counterSmall) + startAngle
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/4 - 5,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
       
        outlineColorSmall.setStroke()
        outlinePath.lineWidth = 10.0
        outlinePath.stroke()
        
    }
}