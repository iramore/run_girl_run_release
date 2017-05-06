import UIKit

import Foundation

@IBDesignable class RunCircles : UIView{
   
    @IBInspectable var bigCircleColor: UIColor = UIColor.blue
    @IBInspectable var smallCircleColor: UIColor = UIColor.orange
    @IBInspectable var outlineColorSmall: UIColor = UIColor.blue
    @IBInspectable var outlineColorBig: UIColor = UIColor.blue
    var outlineColorBigFake = UIColor(hex: "#00ACBC")
    var outlineColorSmallFake = UIColor(hex: "#FE005A")
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


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: bounds.width - bounds.width*(5/6)+3.75,  y: 3.75, width: bounds.width*(5/6)-7.5, height: bounds.width*(5/6)-7.5))
       
        bigCircleColor.setFill()
        
        circlePath.fill()
        
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = π / 2
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        let centerBig = CGPoint(x:bounds.width - bounds.width*5/12, y: bounds.height*5/12)

        let arcLengthPerGlassBig = angleDifference / CGFloat(maxValueBig)
        
        let outlineEndAngleBig = arcLengthPerGlassBig * CGFloat(counterBig) + startAngle
        
        let radiusBig = bounds.width*5/12
        let strokeBig = radiusBig/7
        let outlinePathBigFake = UIBezierPath(arcCenter: centerBig,
                                          radius: radiusBig - strokeBig/2,
                                          startAngle: 0,
                                          endAngle: 2*π,
                                          clockwise: true)
       
        
        
        outlineColorBigFake.setStroke()
        outlinePathBigFake.lineWidth = strokeBig
        outlinePathBigFake.stroke()
        print("big \(outlinePathBigFake.lineWidth)")
        
        let outlinePathBig = UIBezierPath(arcCenter: centerBig,
                                          radius: radiusBig - strokeBig/2,
                                          startAngle: startAngle,
                                          endAngle: outlineEndAngleBig,
                                          clockwise: true)
        
        outlineColorBig.setStroke()
        outlinePathBig.lineWidth = strokeBig
        outlinePathBig.stroke()

        
        let circlePath2 = UIBezierPath(ovalIn: CGRect(x: 2.5,  y: bounds.width*(1/2)+2.5, width: bounds.width*(1/2)-5, height: bounds.width*(1/2)-5))
        let trColor = smallCircleColor.withAlphaComponent(0.7)
        trColor.setFill()
        circlePath2.fill()
        let center = CGPoint(x:bounds.width/4, y: bounds.height*3/4)
        
        let radiusSmall = bounds.width/4
        let strokeSmall = radiusBig/10
        let outlinePathSmallFake = UIBezierPath(arcCenter: center,
                                              radius: radiusSmall - strokeSmall/2,
                                              startAngle: 0,
                                              endAngle: 2*π,
                                              clockwise: true)
        
        outlineColorSmallFake.setStroke()
        outlinePathSmallFake.lineWidth = strokeSmall
        outlinePathSmallFake.stroke()
        
        let arcLengthPerGlass = angleDifference / CGFloat(maxValueSmall)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counterSmall) + startAngle
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: radiusSmall - strokeSmall/2,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
       
        outlineColorSmall.setStroke()
        outlinePath.lineWidth = strokeSmall
        outlinePath.stroke()
        
    }
}
