

import UIKit

class MenuButton: UIButton {
    
   
    var bezierPath: UIBezierPath = UIBezierPath()
    
    init(path: UIBezierPath,  frame: CGRect, image: String) {
        super.init(frame: frame)
        
        
        let image  = UIImage(named: image) as UIImage?
        self.imageView!.contentMode = .scaleAspectFit
        self.setImage(image, for: UIControlState())
        bezierPath = path;

        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        self.layer.mask = mask
        self.frame = frame
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if bezierPath.contains(point) {
            return self
        }
        return nil
    }
}
