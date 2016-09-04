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
    
    
    @IBOutlet weak var runner: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    var transition:ElasticTransition!
   // @IBOutlet weak var pBar1: FMProgressBarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var animationFinished = true
    let shareData = ShareData.sharedInstance
    var trainDays = 0
    var endDate: NSDate?
    var convertedToday: NSDate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .Rotate
        
        let progressPercent = CGFloat(((shareData.userData)!.completedTrainsDates?.count)!) / CGFloat(Train_data.numberOfTrains)
        let image = getMixedImg(runner.frame.width * progressPercent)
        runner.contentMode = .Left
        runner.image = image
        runner.layer.cornerRadius = 9
        runner.layer.borderWidth = 3
        runner.layer.borderColor = UIColor(hex: "#FF7B7B").CGColor
        runner.layer.masksToBounds = true
        
        progressLabel.text = "Completed trainings: \(((shareData.userData)!.completedTrainsDates?.count)!) / 27"
        
       setEndDate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setEndDate()
        print("end date \(endDate)")
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


extension CalViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> CVCalendarWeekday {
        return .Monday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xFFFFFF)
        return circleView
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {

        
            let π = M_PI
            
            let ringSpacing: CGFloat = 3.0
            let ringInsetWidth: CGFloat = 1.0
            let ringVerticalOffset: CGFloat = 1.0
            var ringLayer: CAShapeLayer!
            let ringLineWidth: CGFloat = 4.0
            var ringLineColour : UIColor
            if(dayView.date.convertedDate()! > NSDate() || (dayView.date.convertedDate()! == convertedToday! && !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!) ){
                ringLineColour = UIColor(hex: "#657ECA") //blue
            } else{
                ringLineColour =  UIColor(hex: "#FF7B7B") //brick

            }
        
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
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
       
        if let _ = (shareData.userData)!.completedTrainsDates {
            if let _ = dayView.date{
                if(shareData.userData)!.completedTrainsDates!.contains(dayView.date.convertedDate()!){
                    return true
                }
            }
        }
        
        if ((shareData.userData)!.daysOfWeek.contains(dayView.weekdayIndex-1))
        {
            if  let _ = dayView.date{
                if(dayView.date.convertedDate()! > NSDate() && dayView.date.convertedDate()! < endDate! || (dayView.date.convertedDate()! == convertedToday! && !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!)){
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
            return 7
        }
    }
    
    
    func getDayOfWeek(date: NSDate)->Int{
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, fromDate: date)
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
    func setEndDate() {
        let calendar = NSCalendar.currentCalendar()
        let comps = Manager.componentsForDate(NSDate())
        
        
        comps.year = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: NSDate()).year
        comps.month = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: NSDate()).month
        comps.weekOfMonth = NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfMonth, fromDate: NSDate()).weekOfMonth
        comps.day = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: NSDate()).day
        
        convertedToday = calendar.dateFromComponents(comps)
        
        
        let today = NSDate()
        
        let val = 27 - ((shareData.userData)!.completedTrainsDates?.count)!
        let weeks = val/(shareData.userData)!.daysOfWeek.count
        var tail = val%(shareData.userData)!.daysOfWeek.count
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: today)
        if( !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!
            && (shareData.userData)!.daysOfWeek.contains(toMondayWeekStart(components.weekday)-1)
            ){
            tail -= 1
        }
        
        let endWeek = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .WeekOfMonth,
                value: weeks,
                toDate: today,
                options: []
        )
        var day : NSDate = endWeek!
        while(tail > 0){
            day = NSCalendar.currentCalendar()
                .dateByAddingUnit(
                    .Day,
                    value: 1,
                    toDate: day,
                    options: []
                )!
            let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: day)
            if((shareData.userData)!.daysOfWeek.contains(toMondayWeekStart(components.weekday)-1)){
                tail -= 1
            }
        }
        endDate = day
    }
    
    func getMixedImg(width: CGFloat) -> UIImage {
        let size = CGSizeMake(width, 24)
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var widthVid: CGFloat = 0
        let im: UIImage = UIImage(named: "calMenuRunner")!
        while(widthVid < width){
            im.drawInRect(CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
            widthVid+=im.size.width
        }
        
        
        let finalImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage2
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

    
}
// MARK: Date comporasion
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
