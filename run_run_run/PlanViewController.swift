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
        return 27
    }
    
    @IBAction func dismissButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let ind = (indexPath as NSIndexPath).row
        var result: UIImage
        var data: Date
        var today = DateUtil.getConvertedToday()
        var offset: Int
        if  (ShareData.sharedInstance.userData?.completedTrainsDates?.contains(today))! {
            offset = 0
        } else{
            offset = 1
        }
        if(ind < (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!){
            result = UIImage(named: "run-run-\(ind+1)wt")!
            data = (ShareData.sharedInstance.userData?.completedTrainsDates?[ind])!
        }
        else if ind == (ShareData.sharedInstance.userData?.completedTrainsDates?.count)! {
            
            if  (ShareData.sharedInstance.userData?.completedTrainsDates?.contains(today))! {
                today = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                today = findNextTrainDateStartFromTommorow(prevTrain: today, index: 1)
                data = today
                result = UIImage(named: "run-run-\(ind+1)")!
                //сегодня НЕ может быть отображено как следующий день тренировки
               
            } else{
                var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: today)
                while(!(ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))!){ //или сегодня или ищем следующий день
                    today = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                    dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: today)
                }
                data = today
                result = UIImage(named: "run-run-\(ind+1)")!
                
                //сегодня может быть отобраено как следующий день тренировки
            }
            
        }
        else {
            print("ind \(ind)")
            today = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            today = findNextTrainDateStartFromTommorow(prevTrain: today, index: (ind - (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!) + 1 - offset)
            data = today
            result = UIImage(named: "run-run-\(ind+1)")!
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode!)
        formatter.dateStyle = .long
        cell.date.text = formatter.string(from: data)
        cell.planImage.image = result
        return cell
    }
    
    
    func findNextTrainDateStartFromTommorow(prevTrain: Date, index: Int) -> Date{
        print(index)
        var nextDate = prevTrain
        var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: nextDate)
        var ind = 0
        while(index != ind){
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
