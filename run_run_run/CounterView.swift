import UIKit


let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CounterView: UIView {
  
  @IBInspectable var counter: Int = 5 {
    didSet {
      if counter <=  maxValue {
        //the view needs to be refreshed
        setNeedsDisplay()
      }
    }
  }
    
    var maxValue:Int = 10
  @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
  @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var arcWidth: CGFloat = 45.0
  
  override func drawRect(rect: CGRect) {
    
    let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
    
    
    let radius: CGFloat = max(bounds.width, bounds.height)
    
    let startAngle: CGFloat = π / 2
    let endAngle: CGFloat = π / 2
    
    
    
    
    var path = UIBezierPath(arcCenter: center,
      radius: radius/2 - arcWidth/2,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: false)
    
    path.lineWidth = arcWidth
    counterColor.setStroke()
    path.stroke()
    
    
    let angleDifference: CGFloat = 2 * π - startAngle + endAngle
    
    let arcLengthPerGlass = angleDifference / CGFloat(maxValue)
    
       let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
    
   
    var outlinePath = UIBezierPath(arcCenter: center,
      radius: bounds.width/2 - 2.5,
      startAngle: startAngle,
      endAngle: outlineEndAngle,
      clockwise: true)
    
        outlinePath.addArcWithCenter(center,
      radius: bounds.width/2 - arcWidth + 2.5,
      startAngle: outlineEndAngle,
      endAngle: startAngle,
      clockwise: false)

    outlinePath.closePath()
    
    outlineColor.setStroke()
    outlineColor.setFill()
    outlinePath.lineWidth = 5.0
    outlinePath.stroke()
  }
}
