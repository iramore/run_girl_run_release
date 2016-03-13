//
//  UserData.swift
//  run_run_run
//
//  Created by infuntis on 11.03.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

class UserData: NSObject,NSCoding {
    
    // MARK: Properties
    
    var trainNumber: Int
    var daysOfWeek: [Int]
    var completedTrainsDates: [NSDate]?
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains:.UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("run_user_data")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let trainNumberKey = "trainNumber"
        static let daysOfWeekKey = "daysOfWeek"
        static let completedTrainsDatesKey = "completedTrainsDates"
    }
    
    // MARK: Initialization
    
    init?(trainNumber: Int, daysOfWeek: [Int]) {
        // Initialize stored properties.
        self.trainNumber = trainNumber
        self.daysOfWeek = daysOfWeek
        //self.completedTrainsDates = completedTrainsDates
        super.init()
    }
    
    init?(trainNumber: Int, daysOfWeek: [Int], completedTrainsDates: [NSDate]) {
        // Initialize stored properties.
        self.trainNumber = trainNumber
        self.daysOfWeek = daysOfWeek
        self.completedTrainsDates = completedTrainsDates
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(trainNumber, forKey: PropertyKey.trainNumberKey)
        aCoder.encodeObject(daysOfWeek, forKey: PropertyKey.daysOfWeekKey)
        aCoder.encodeObject(completedTrainsDates, forKey: PropertyKey.completedTrainsDatesKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let trainNumber = aDecoder.decodeObjectForKey(PropertyKey.trainNumberKey) as! Int
        let daysOfWeek = aDecoder.decodeObjectForKey(PropertyKey.daysOfWeekKey) as! [Int]
        if let completedTrainsDates = aDecoder.decodeObjectForKey(PropertyKey.completedTrainsDatesKey) as? [NSDate] {
            self.init(trainNumber: trainNumber, daysOfWeek: daysOfWeek, completedTrainsDates: completedTrainsDates)
        } else {
            self.init(trainNumber: trainNumber, daysOfWeek: daysOfWeek)
        }
    }
    
    
}
