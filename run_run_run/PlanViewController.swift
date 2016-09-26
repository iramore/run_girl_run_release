//
//  ViewController.swift
//  run_run_run
//
//  Created by infuntis on 14.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import ElasticTransition
import BMCustomTableView

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var planImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class PlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let shareData = ShareData.sharedInstance
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 27
        
    }
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        let ind = indexPath.row + 1
        var result: UIImage
        if(ind <= (ShareData.sharedInstance.userData?.completedTrainsDates?.count)!){
            result = UIImage(named: "run-run-\(ind)wt")!
        } else {
            //result = UIImage(named: "Image")!
            result = UIImage(named: "run-run-\(ind)")!
        }
       
        cell.planImage.image = result
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        customTableView.customizeCell(cell)
        
    }
    
}
