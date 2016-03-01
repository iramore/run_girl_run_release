//
//  RunViewController.swift
//  run_run_run
//
//  Created by infuntis on 29.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

class RunViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
