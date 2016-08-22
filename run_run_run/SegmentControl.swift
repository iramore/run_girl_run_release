//
//  SegmentControl.swift
//  run_run_run
//
//  Created by infuntis on 30.07.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import UIKit


@objc protocol SegmentControlDelegate {
    optional func segmentChanged(control: SegmentControl, value: Int)
}

class SegmentControl: UIView{
    var delegate: SegmentControlDelegate?
    var buttonTitles = [String]()
    var borderColor = UIColor(hex: "#FF7B7B")
    //var borderColor = UIColor(hex: "#F26F7A")
    var textColor = UIColor(hex: "#54504C")
    var name: String = ""
    var font = UIFont(name: "Pragmatica", size: 24)
    var selectedIndexes = [Int](){
        didSet {
            setNeedsDisplay()
        }
    }
    var segmentButtons = [UIButton]()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //print("DRAW RECT \(name)   \(selectedIndexes)")
        self.removeAllSubviews()
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.masksToBounds = true
            for (index, button) in buttonTitles.enumerate() {
                let buttonWidth = self.frame.width / CGFloat(buttonTitles.count)
                let buttonHeight = self.frame.height
                
                let newButton = UIButton(frame: CGRectMake(CGFloat(index) * buttonWidth, 0, buttonWidth, buttonHeight))
                newButton.setTitle(button, forState: .Normal)
                
                newButton.titleLabel?.font = self.font!
                newButton.addTarget(self, action: #selector(SegmentControl.setSelected(_:)), forControlEvents: .TouchUpInside)
                newButton.layer.borderWidth = 1
                newButton.layer.borderColor = self.borderColor.CGColor
                newButton.tag = index
                newButton.showsTouchWhenHighlighted = true
                for selected in selectedIndexes {
                    if selected == index {
                        newButton.backgroundColor = borderColor
                        newButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        break
                    } else {
                        newButton.setTitleColor(self.textColor, forState: .Normal)
                        newButton.backgroundColor = UIColor.clearColor()
                    }
                }
                self.addSubview(newButton)
                
              
            }
    }
    
    func setSelected(sender: UIButton) {
        let value = buttonTitles.indexOf(sender.titleLabel!.text!)
        self.delegate?.segmentChanged!(self, value: value!)

//        if sender.backgroundColor == borderColor {
//            sender.backgroundColor = UIColor.clearColor()
//            sender.setTitleColor(textColor, forState: .Normal)
//            let value = buttonTitles.indexOf(sender.titleLabel!.text!)
//            self.delegate?.segmentChanged!(self, value: value!)
//        
//        } else{
//            sender.backgroundColor = borderColor
//            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            let value = buttonTitles.indexOf(sender.titleLabel!.text!)
//            self.delegate?.segmentChanged!(self, value: value!)
//        }
        
    }
    
    

    
}