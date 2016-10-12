//
//  CalViewController.swift
//  run_run_run
//
//  Created by infuntis on 23.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import CVCalendar
import ElasticTransition
import Foundation




class CalViewController: UIViewController {
    
    
    @IBOutlet weak var runner: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    var transition:ElasticTransition!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var animationFinished = true
    let shareData = ShareData.sharedInstance
    var trainDays = 0
    var endDate: Date?
    var convertedToday: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = CVDate(date: Date()).globalDescription
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .rotate
        
        let progressPercent = CGFloat(((shareData.userData)!.completedTrainsDates?.count)!) / CGFloat(Train_data.numberOfTrains)
        let image = getMixedImg(runner.frame.width * progressPercent)
        runner.contentMode = .left
        runner.image = image
        runner.layer.cornerRadius = 9
        runner.layer.borderWidth = 3
        runner.layer.borderColor = UIColor(hex: "#FF7B7B").cgColor
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
        calendarView.contentController.refreshPresentedMonth()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    @IBAction func settingsTouched(_ sender: AnyObject) {
        transition.edge = .bottom
        transition.startingPoint = sender.center
        performSegue(withIdentifier: "settings", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}


extension CalViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> CVCalendarWeekday {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Locale.current.languageCode!)
        if calendar.firstWeekday==2{
            return .monday
        } else{
            return .sunday
        }
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
        return .short
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.circle)
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
            if(dayView.date.convertedDate()! > Date() || (dayView.date.convertedDate()! == convertedToday! && !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!) ){
                ringLineColour = UIColor(hex: "#657ECA") //blue
            } else{
                ringLineColour =  UIColor(hex: "#FF7B7B") //brick

            }
        
            let newView = UIView(frame: dayView.bounds)
            
            let diameter: CGFloat = (newView.bounds.width) - ringSpacing
            let radius: CGFloat = diameter / 2.0
            
            let rect = CGRect(x: newView.frame.midX-radius, y: newView.frame.midY-radius-ringVerticalOffset, width: diameter, height: diameter)
            
            ringLayer = CAShapeLayer()
            newView.layer.addSublayer(ringLayer)
            
            ringLayer.fillColor = nil
            ringLayer.lineWidth = ringLineWidth
            ringLayer.strokeColor = ringLineColour.cgColor
            
            let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
            let ringRect: CGRect = rect.insetBy(dx: ringLineWidthInset, dy: ringLineWidthInset)
            let centrePoint: CGPoint = CGPoint(x: ringRect.midX, y: ringRect.midY)
            let startAngle: CGFloat = CGFloat(-π/2.0)
            let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
            let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            ringLayer.path = ringPath.cgPath
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
                if(dayView.date.convertedDate()! > Date() && dayView.date.convertedDate()! < endDate! || (dayView.date.convertedDate()! == convertedToday! && !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!)){
                    return true
                }
            
            }
        }
        return false
    }
    
    func toMondayWeekStart(_ weekDaySun: Int) -> Int{
        if(weekDaySun>=2){
            return weekDaySun - 1
        } else{
            return 7
        }
    }
    
    
    func getDayOfWeek(_ date: Date)->Int{
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            return weekDay
        
    }
    
    func setEndDate() {
       
        
        let date = Date()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Locale.current.languageCode!)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        
        var components = DateComponents()
        components.setValue(month, for: .month)
        components.setValue(year, for: .year)
        components.setValue(day, for: .day)
        convertedToday = Calendar.current.date(from: components)
        
        
        let today = Date()
        let val = 27 - ((shareData.userData)!.completedTrainsDates?.count)!
        let weeks = val/(shareData.userData)!.daysOfWeek.count
        var tail = val%(shareData.userData)!.daysOfWeek.count
        if( !((shareData.userData)!.completedTrainsDates?.contains(convertedToday!))!
            && (shareData.userData)!.daysOfWeek.contains(DateUtil.dayOfWeekToCurrentLocale(date: today))
            ){
            tail -= 1
        }
        
        
        let endWeek  =  Calendar.current.date(byAdding: .weekOfMonth, value: weeks, to: today)
        
        
        var dayCurrent : Date = endWeek!
        while(tail > 0){
            dayCurrent = Calendar.current.date(byAdding: .day, value: 1, to: dayCurrent)!
            if((shareData.userData)!.daysOfWeek.contains(DateUtil.dayOfWeekToCurrentLocale(date: dayCurrent))){
                tail -= 1
            }
        }
        endDate = dayCurrent
    }
    
    func getMixedImg(_ width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: 24)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var widthVid: CGFloat = 0
        let im: UIImage = UIImage(named: "calMenuRunner")!
        while(widthVid < width){
            im.draw(in: CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
            widthVid+=im.size.width
        }
        
        
        let finalImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage2!
    }


    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }

    
}
