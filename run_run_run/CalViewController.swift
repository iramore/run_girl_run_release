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
    var transition = ElasticTransition()
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var animationFinished = true
    let shareData = ShareData.sharedInstance
    var trainDays = 0
    var endDate: Date?
    var convertedToday: Date?
    var currentCalendar: Calendar?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentCalendar = Calendar.current
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .rotate
        transition.stiffness = 0.9
        
        let progressPercent = CGFloat(((shareData.userData)!.completedTrainsDates?.count)!) / CGFloat(Train_data.numberOfTrains)
        if progressPercent > 0 {
            let image = getMixedImg(runner.frame.width * progressPercent)
            runner.image = image
        }
        runner.contentMode = .left
        
        runner.layer.cornerRadius = 12
        runner.layer.borderWidth = 5
        //runner.layer.shadowOpacity = 1.0
        //runner.layer.shadowOffset = CGSize(width: 25.0,height: 25.0)
        //runner.layer.shadowRadius = 5
        runner.layer.borderColor = UIColor(hex: "#FFC200").cgColor
        //runner.layer.backgroundColor = UIColor.blue.cgColor
        runner.layer.masksToBounds = true
        
        progressLabel.text = "\(NSLocalizedString("calendar.completed", comment: "")) \(((shareData.userData)!.completedTrainsDates?.count)!) / 27"
        settingsBtn.titleLabel?.font = UIFont(name: "Arial-Black", size: 25.0)
        settingsBtn.titleLabel?.textColor = UIColor(hex: "#FFFFFF")
        settingsBtn.setTitle(NSLocalizedString("calPage.settingsButton", comment: ""),for: UIControlState())
        
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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        SKTAudio.sharedInstance().playSoundEffect("pop.wav")
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
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = M_PI
        
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 4.0
        var ringLineColour : UIColor
        if(dayView.date.convertedDate(calendar: currentCalendar!)! > Date() || (dayView.date.convertedDate(calendar: currentCalendar!)! == DateUtil.getConvertedToday() && !((shareData.userData)!.completedTrainsDates?.contains(DateUtil.getConvertedToday()))!) ){
            ringLineColour = UIColor(hex: "#657ECA")
        } else{
            ringLineColour =  UIColor(hex: "#FF7B7B")
        }
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - ringLineWidth
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
        
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        
        guard let currentCalendar = currentCalendar else {
            return false
        }
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)
        
        if let _ = (shareData.userData)!.completedTrainsDates {
            if let _ = dayView.date{
                if(shareData.userData)!.completedTrainsDates!.contains(dayView.date.convertedDate(calendar: currentCalendar)!){
                    return true
                }
            }
        }
        
        if (shareData.userData)!.daysOfWeek.contains(dayView.weekdayIndex-1)
        {
            
            if  let _ = dayView.date{
                if(dayView.date.convertedDate(calendar: currentCalendar)! > DateUtil.getConvertedToday() && dayView.date.convertedDate(calendar: currentCalendar)! <= endDate! || (dayView.date.convertedDate(calendar: currentCalendar)! == DateUtil.getConvertedToday() && !((shareData.userData)!.completedTrainsDates?.contains(DateUtil.getConvertedToday()))!)){
                    return true
                }
            }
        }
        return false
    }
    func setEndDate() {

        let val = 27 - ((shareData.userData)!.completedTrainsDates?.count)!
        var endDateTemp = DateUtil.getConvertedToday()
        if(ShareData.sharedInstance.userData?.completedTrainsDates?.contains(DateUtil.getConvertedToday()))!
        {
            endDateTemp = Calendar.current.date(byAdding: .day, value: 1, to: endDateTemp)!
        }
        var ind = 0
        var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: endDateTemp)
        if (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
            ind += 1
        }
        while(ind != val){
            endDateTemp = Calendar.current.date(byAdding: .day, value: 1, to: endDateTemp)!
            dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: endDateTemp)
            if (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
                ind += 1
            }
        }
        endDate = DateUtil.getDateToLocale(date: endDateTemp)
        
    }
    
    func getMixedImg(_ width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: 24)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var widthVid: CGFloat = 0
        var im = UIImage(named: "cal_image_1")!
        var imN = 1
        while(widthVid < width){
            im.draw(in: CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
            widthVid+=im.size.width
            if imN == 1 {
            im = UIImage(named: "cal_image_2")!
                imN = 2
            } else{
                im = UIImage(named: "cal_image_1")!
                imN = 1
            }
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
