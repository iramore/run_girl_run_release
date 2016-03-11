//
//  Train.swift
//  run_run_run
//
//  Created by infuntis on 07.03.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

class Train: NSObject {
    
    var trainMenu = [UIImage]()
    var index: Int = 0
    var temp = [Float]()
    
    init(index: Int, trainMenu: [UIImage]?, temp: [Float]) {
        self.index = index
        self.trainMenu = trainMenu!
        self.temp = temp
    }
    
    // MARK: Types
    
    struct PropertyKey {
        static let trainMenuKey = "trainMenu"
        static let indexKey = "index"
        static let tempKey = "temp"
    }
    
    
}
