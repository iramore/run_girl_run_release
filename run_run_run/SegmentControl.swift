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
    @objc optional func segmentChanged(_ control: SegmentControl, value: Int)
}

class SegmentControl: UIView{
    var delegate: SegmentControlDelegate?
    var buttonTitles = [String]()
    var borderColor = UIColor(hex: "#FF7B7B")
    //var borderColor = UIColor(hex: "#F26F7A")
    var textColor = UIColor(hex: "#54504C")
    var name: String = ""
    var font = UIFont(name: "Avenir", size: 24)
    var selectedIndexes = [Int](){
        didSet {
            setNeedsDisplay()
        }
    }
    var segmentButtons = [UIButton]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //print("DRAW RECT \(name)   \(selectedIndexes)")
        self.removeAllSubviews()
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.masksToBounds = true
            for (index, button) in buttonTitles.enumerated() {
                let buttonWidth = self.frame.width / CGFloat(buttonTitles.count)
                let buttonHeight = self.frame.height
                
                let newButton = UIButton(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
                newButton.setTitle(button, for: UIControlState())
                
                newButton.titleLabel?.font = self.font!
                newButton.addTarget(self, action: #selector(SegmentControl.setSelected(_:)), for: .touchUpInside)
                newButton.layer.borderWidth = 1
                newButton.layer.borderColor = self.borderColor.cgColor
                newButton.tag = index
                newButton.showsTouchWhenHighlighted = true
                for selected in selectedIndexes {
                    if selected == index {
                        newButton.backgroundColor = borderColor
                        newButton.setTitleColor(UIColor.white, for: UIControlState())
                        break
                    } else {
                        newButton.setTitleColor(self.textColor, for: UIControlState())
                        newButton.backgroundColor = UIColor.clear
                    }
                }
                self.addSubview(newButton)
                
              
            }
    }
    
    func setSelected(_ sender: UIButton) {
        let value = buttonTitles.index(of: sender.titleLabel!.text!)
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
