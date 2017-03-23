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
        var data = DateUtil.getConvertedToday()
        let completedTrains = (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!
        let compTrainsDates = ShareData.sharedInstance.userData?.completedTrainsDates!
        if ind < completedTrains {
            result = UIImage(named: "run-run-\(ind+1)wt")!
            data = (ShareData.sharedInstance.userData?.completedTrainsDates?[ind])!
        }
        else
        {
            if (compTrainsDates?.contains(DateUtil.getConvertedToday()))! {
                data = Calendar.current.date(byAdding: .day, value: 1, to: data)!
            }
            data = nextTrainDate(prevDate: data, index: ind - completedTrains + 1)
            result = UIImage(named: "run-run-\(ind+1)")!
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode!)
        formatter.dateStyle = .long
        cell.date.text = "\(formatter.string(from: data))"
        cell.planImage.image = result
        return cell
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
