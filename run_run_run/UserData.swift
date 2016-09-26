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
    
    var daysOfWeek: [Int]
    var completedTrainsDates: [Date]?
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("run_user_data")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let daysOfWeekKey = "daysOfWeek"
        static let completedTrainsDatesKey = "completedTrainsDates"
    }
    
    // MARK: Initialization
    
    init?(daysOfWeek: [Int]) {
        // Initialize stored properties.
        self.daysOfWeek = daysOfWeek
        super.init()
    }
    
    init?(daysOfWeek: [Int], completedTrainsDates: [Date]) {
        // Initialize stored properties.
        self.daysOfWeek = daysOfWeek
        self.completedTrainsDates = completedTrainsDates
        super.init()
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {

        aCoder.encode(daysOfWeek, forKey: PropertyKey.daysOfWeekKey)
        aCoder.encode(completedTrainsDates, forKey: PropertyKey.completedTrainsDatesKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let daysOfWeek = aDecoder.decodeObject(forKey: PropertyKey.daysOfWeekKey) as! [Int]
        if let completedTrainsDates = aDecoder.decodeObject(forKey: PropertyKey.completedTrainsDatesKey) as? [Date] {
            self.init(daysOfWeek: daysOfWeek, completedTrainsDates: completedTrainsDates)
        } else {
            self.init(daysOfWeek: daysOfWeek)
        }
    }
    
    
}
