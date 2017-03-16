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
    var lastTrainingDate = DateUtil.getConvertedToday()
    
    
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
        if(ind < (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!){
            result = UIImage(named: "run-run-\(ind+1)wt")!
            data = (ShareData.sharedInstance.userData?.completedTrainsDates?[ind])!
        }
        else if ind == (ShareData.sharedInstance.userData?.completedTrainsDates?.count)! {
            if  !(ShareData.sharedInstance.userData?.completedTrainsDates?.contains(lastTrainingDate))! {
                var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: lastTrainingDate)
                while(!(ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))!){
                    lastTrainingDate = Calendar.current.date(byAdding: .day, value: 1, to: lastTrainingDate)!
                    dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: lastTrainingDate)
                }
                data = lastTrainingDate
                result = UIImage(named: "run-run-\(ind+1)")!
            } else{
                lastTrainingDate = Calendar.current.date(byAdding: .day, value: 1, to: lastTrainingDate)!
                lastTrainingDate = findNextTrainDate(prevTrain: lastTrainingDate)
                print(lastTrainingDate)
                data = lastTrainingDate
                result = UIImage(named: "run-run-\(ind+1)")!
            }
            
        }
        else {
            lastTrainingDate = Calendar.current.date(byAdding: .day, value: 1, to: lastTrainingDate)!
            lastTrainingDate = findNextTrainDate(prevTrain: lastTrainingDate)
            data = lastTrainingDate
            result = UIImage(named: "run-run-\(ind+1)")!
           
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode!)
        formatter.dateStyle = .medium
        cell.date.text = formatter.string(from: data)
        cell.planImage.image = result
        return cell
    }
    
    func findNextTrainDate(prevTrain: Date) -> Date{
        var nextDate = prevTrain
        var dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: nextDate)
        while(!(ShareData.sharedInstance.userData?.daysOfWeek.contains(dayOfWeek-1))!){
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!
            dayOfWeek = DateUtil.dayOfWeekToCurrentLocale(date: nextDate)
        }
        return nextDate
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        customTableView.customizeCell(cell: cell)
        
    }
    
}
