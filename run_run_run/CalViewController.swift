//
//  CalViewController.swift
//  run_run_run
//
//  Created by infuntis on 23.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import CVCalendar
import ActionSheetPicker_3_0
import ElasticTransition
import Foundation




class CalViewController: UIViewController {
    
    
    var transition:ElasticTransition!
    @IBOutlet weak var pBar1: FMProgressBarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var animationFinished = true
    let shareData = ShareData.sharedInstance
    var trainDays = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .Rotate
        pBar1.progressPercent = CGFloat(Train_data.numberOfTrains) / CGFloat(((shareData.userData)!.completedTrainsDates?.count)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.contentController.refreshPresentedMonth()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        
    }
    
    @IBAction func settingsTouched(sender: AnyObject) {
        transition.edge = .Bottom
        transition.startingPoint = sender.center
        performSegueWithIdentifier("settings", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> CVCalendarWeekday {
        return .Monday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    //line between weeks in calendar
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0x657ECA)
        return circleView
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {

        if(dayView.date.convertedDate()! > NSDate()){
            let π = M_PI
            
            let ringSpacing: CGFloat = 3.0
            let ringInsetWidth: CGFloat = 1.0
            let ringVerticalOffset: CGFloat = 1.0
            var ringLayer: CAShapeLayer!
            let ringLineWidth: CGFloat = 4.0
            let ringLineColour: UIColor = UIColor(hex: "#657ECA")
            
            let newView = UIView(frame: dayView.bounds)
            
            let diameter: CGFloat = (newView.bounds.width) - ringSpacing
            let radius: CGFloat = diameter / 2.0
            
            let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
            
            ringLayer = CAShapeLayer()
            newView.layer.addSublayer(ringLayer)
            
            ringLayer.fillColor = nil
            ringLayer.lineWidth = ringLineWidth
            ringLayer.strokeColor = ringLineColour.CGColor
            
            let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
            let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
            let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
            let startAngle: CGFloat = CGFloat(-π/2.0)
            let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
            let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            ringLayer.path = ringPath.CGPath
            ringLayer.frame = newView.layer.bounds
            
            return newView
        }
        else {
            let π = M_PI
            
            let ringSpacing: CGFloat = 3.0
            let ringInsetWidth: CGFloat = 1.0
            let ringVerticalOffset: CGFloat = 1.0
            var ringLayer: CAShapeLayer!
            let ringLineWidth: CGFloat = 4.0
            let ringLineColour: UIColor =  UIColor(hex: "#FF7B7B")
            
            let newView = UIView(frame: dayView.bounds)
            
            let diameter: CGFloat = (newView.bounds.width) - ringSpacing
            let radius: CGFloat = diameter / 2.0
            
            let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
            
            ringLayer = CAShapeLayer()
            newView.layer.addSublayer(ringLayer)
            
            ringLayer.fillColor = nil
            ringLayer.lineWidth = ringLineWidth
            ringLayer.strokeColor = ringLineColour.CGColor
            
            let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
            let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
            let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
            let startAngle: CGFloat = CGFloat(-π/2.0)
            let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
            let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            ringLayer.path = ringPath.CGPath
            ringLayer.frame = newView.layer.bounds
            
            return newView
        }
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
       
        if let _ = (shareData.userData)!.completedTrainsDates {
            if let _ = dayView.date{
                if(shareData.userData)!.completedTrainsDates!.contains(dayView.date.convertedDate()!){
                    return true
                }
            }
        }
        let today = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: today)
        print(components.weekday)
        print("======")
        print(toMondayWeekStart(components.weekday))
        print((shareData.userData)!.daysOfWeek)
       
        let val = 7 - ((shareData.userData)!.completedTrainsDates?.count)!
        let weeks = val/(shareData.userData)!.daysOfWeek.count
        var tail = val%(shareData.userData)!.daysOfWeek.count
        
        let endWeek = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .WeekOfMonth,
                value: weeks,
                toDate: today,
                options: []
        )
        var day = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .Day,
                value: 1,
                toDate: endWeek!,
                options: []
        )
        while(tail > 0){
            let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: day!)
                if((shareData.userData)!.daysOfWeek.contains(toMondayWeekStart(components.weekday))){
                tail -= 1
            }
            day = NSCalendar.currentCalendar()
                .dateByAddingUnit(
                    .Day,
                    value: 1,
                    toDate: day!,
                    options: []
            )
            
        }
        if ((shareData.userData)!.daysOfWeek.contains(dayView.weekdayIndex-1))
        {
            if  let _ = dayView.date{
                if(dayView.date.convertedDate()! > NSDate() && dayView.date.convertedDate()! < day){
                    return true
                }
            
            }
        }
        return false
    }
    
    func toMondayWeekStart(weekDaySun: Int) -> Int{
        if(weekDaySun>=2){
            return weekDaySun - 1
        } else{
            return 6
        }
    }
    
    func getFirstTale(today: Int, total: Int) -> Int{
        var lastIndex: Int = -1
        print("today \(today)")
        for index in (shareData.userData)!.daysOfWeek {
            if(index > today)  {
                lastIndex = index
                break
            }
        }
        return lastIndex == -1 ? 0 :(shareData.userData)!.daysOfWeek.count - (shareData.userData)!.daysOfWeek.indexOf(lastIndex)! + 1
    }
    
    func getDayOfWeek(date: NSDate)->Int{
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, fromDate: date)
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
}
// MARK: Date comporasion
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
