//
//  SettingsViewController.swift
//  run_run_run
//
//  Created by infuntis on 27.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

import ActionSheetPicker_3_0
import ElasticTransition

class SettingsCell:UITableViewCell{
    
    @IBOutlet weak var stringPicker: UIButton!
}

class SettingsViewController: UIViewController, ElasticMenuTransitionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var objects: NSMutableArray! = NSMutableArray()
    var daysOfWeekArray:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var arrayForDayChooser = Array<Array<String>>()
    
    var selectedDays: [Int] = [1,3,5]
    var contentLength:CGFloat = 0
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objects.addObject("3 days a week")
        self.objects.addObject("Mon Wed Fri")

        tableView.reloadData()

    }

    @IBAction func buttonPressed(sender: AnyObject) {
        ActionSheetMultipleStringPicker.showPickerWithTitle("Days of the week", rows: arrayForDayChooser, initialSelection: [0, 1, 2, 4, 5], doneBlock: {
            picker, values, indexes in
            
            print("values = \(values)")
            print("indexes = \(indexes)")
            print("picker = \(picker)")
            return
            }, cancelBlock: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    
    func daysOfWeekButtonPressed(sender: AnyObject){
        if(arrayForDayChooser.isEmpty){
            for _ in 0...2 {
                self.arrayForDayChooser.append(daysOfWeekArray)
            }
            
        }
       
    }
    
    func timesInWeekButtonPressed(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Trains per week", rows: ["1 day a week", "2 days a week", "3 days a week", "4 days a week", "5 days a week"], initialSelection: 2, doneBlock: {
            picker, value, index in
            self.arrayForDayChooser.removeAll()
            self.selectedDays.removeAll()
            self.view.reloadInputViews()
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            self.changeNumberOfDaysPickerName(index as! String, numberOfTheDay: value)
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func changeNumberOfDaysPickerName(daysAWeek : String, var numberOfTheDay : Int){
       // numperOfWeekButton.setTitle(daysAWeek, forState: .Normal)
        for _ in 0...numberOfTheDay {
            self.arrayForDayChooser.append(daysOfWeekArray)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("setting", forIndexPath: indexPath) as! SettingsCell
        
        cell.stringPicker.setTitle(self.objects.objectAtIndex(indexPath.row) as? String, forState: .Normal)
        
        cell.stringPicker.tag = indexPath.row;
        cell.stringPicker.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }

}

