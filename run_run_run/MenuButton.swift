

import UIKit

class MenuButton: UIButton {
    
   
    var bezierPath: UIBezierPath = UIBezierPath()
    
    var action: ((AnyObject?) -> ())? = nil
    
    init(path: UIBezierPath,  frame: CGRect, image: String) {
        super.init(frame: frame)
        
        
        let image  = UIImage(named: image) as UIImage?
        self.imageView!.contentMode = .ScaleAspectFit
       // self.imageView!.image?.renderingMode = .AlwaysOriginal
        self.setImage(image, forState: .Normal)
        
        //self.backgroundColor = UIColor.blackColor()
        bezierPath = path;

        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.CGPath
        self.layer.mask = mask
        self.frame = frame
        self.addTarget(self, action: #selector(MenuButton.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func buttonAction(sender: UIButton) {
        action?(sender)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        //return super.hitTest(point, withEvent: event)
        if bezierPath.containsPoint(point) {
            return self
        }
        return nil
    }
}
