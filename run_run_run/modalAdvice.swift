//
//  modalAdvice.swift
//  run_run_run
//
//  Created by infuntis on 16/03/17.
//  Copyright © 2017 gala. All rights reserved.
//

import UIKit

protocol modalAdviceDelegate: class {
    func notificationAlloweded()
    func notificationNotAlloweded()
}

class modalAdvice: UIViewController {
    var delegate:modalAdviceDelegate?
    
    @IBOutlet weak var notOkButton: UIButton!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adviceLabel.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        adviceLabel.text = NSLocalizedString("modalWindow.NotificationAdvice", comment: "")
        okButton.setTitle(NSLocalizedString("askNotifPage.ok", comment: ""), for: UIControlState())
        notOkButton.setTitle(NSLocalizedString("askNotifPage.notOk", comment: ""), for: UIControlState())
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func notOkAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.notificationNotAlloweded()
        })
    }
    @IBAction func okAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.notificationAlloweded()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

