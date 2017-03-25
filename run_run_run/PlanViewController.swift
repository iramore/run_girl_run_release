//
//  ViewController.swift
//  run_run_run
//
//  Created by infuntis on 14.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import BMCustomTableView

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var planImage: UIImageView!
    
    
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class PlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let shareData = ShareData.sharedInstance
    var todayRow: Int?
    var restCellNeeded = false
    //var lastTrainingDate = DateUtil.getConvertedToday()
    
    
    //MARK: Variables
    //var colors: [UIColor]!
    
    //MARK: Outlets
    @IBOutlet weak var customTableView: BMCustomTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //colors = randomColorsCount(27, hue: .Pink, luminosity: .Light)
        self.customTableView.contentInset = UIEdgeInsetsMake(0, 0, 25, 0)
        //customTableView.frame = self.view.frame;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let compTrainsDates = ShareData.sharedInstance.userData?.completedTrainsDates!
        let dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: DateUtil.getConvertedToday())
        if (compTrainsDates?.contains(DateUtil.getConvertedToday()))! || (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
            return 27
        } else{
            return 28
        }
    }
    
    @IBAction func todayButtonPressed(_ sender: Any) {
        /* let compTrainsDates = ShareData.sharedInstance.userData?.completedTrainsDates!
         var ind: Int
         if (compTrainsDates?.contains(DateUtil.getConvertedToday()))!{
         ind = (compTrainsDates?.index(of: DateUtil.getConvertedToday()))!
         print(ind)
         } else{
         ind = 12
         } */
        let indexPath = NSIndexPath(row: todayRow!, section: 0)
        self.customTableView.scrollToRow(at: indexPath as IndexPath,
                                         at: UITableViewScrollPosition.middle, animated: true)
    }
    @IBAction func dismissButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let ind = (indexPath as NSIndexPath).row
        var result: UIImage
        var data = DateUtil.getConvertedToday()
        let completedTrains = (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!
        let compTrainsDates = ShareData.sharedInstance.userData?.completedTrainsDates!
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode!)
        formatter.dateStyle = .long
        if isRestCell(index: ind){
            restCellNeeded = true
            cell.planImage.image = UIImage(named: "rest")!
            todayRow = ind
            cell.date.text = "\(NSLocalizedString("plan.today", comment: "")): \(formatter.string(from: DateUtil.getConvertedToday()))"
            return cell
        }
        
        if ind < completedTrains {
            result = UIImage(named: "run-run-\(ind+1)wt")!
            data = (ShareData.sharedInstance.userData?.completedTrainsDates?[ind])!
        }
        else
        {
            if (compTrainsDates?.contains(DateUtil.getConvertedToday()))! {
                data = Calendar.current.date(byAdding: .day, value: 1, to: data)!
            }
            
            if restCellNeeded {
                result = UIImage(named: "run-run-\(ind)")!
                data = nextTrainDate(prevDate: data, index: ind - completedTrains)
            } else{
                result = UIImage(named: "run-run-\(ind+1)")!
                data = nextTrainDate(prevDate: data, index: ind - completedTrains + 1)
            }
        }
        
        
        if data == DateUtil.getConvertedToday() {
            todayRow = ind
            cell.date.text = "\(NSLocalizedString("plan.today", comment: "")): \(formatter.string(from: data))"
        } else{
            cell.date.text = "\(formatter.string(from: data))"
        }
        cell.planImage.image = result
        return cell
    }
    
    
    func isRestCell(index: Int)->Bool{
        let completedTrains = (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!
        let compTrainsDates = ShareData.sharedInstance.userData?.completedTrainsDates!
        let dayOfWeekToday = DateUtil.dayOfWeekToCurrentLocale(date: DateUtil.getConvertedToday())
        return index == completedTrains && !(ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeekToday-1))! &&
            !(compTrainsDates?.contains(DateUtil.getConvertedToday()))!
        
    }
    
    func nextTrainDate(prevDate: Date, index: Int) -> Date{
        var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: prevDate)
        var ind = 0
        var nextDate = prevDate
        if (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
            ind += 1
        }
        while(ind != index){
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!
            dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: nextDate)
            if (ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))! {
                ind += 1
            }
        }
        return nextDate
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        customTableView.customizeCell(cell: cell)
        
    }
    
}
