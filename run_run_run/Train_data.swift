//
//  Train_data.swift
//  run_run_run
//
//  Created by infuntis on 11.03.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

class Train_data: NSObject {
    static var numberOfTrains : Int = 27
    
    static var train1: Train = Train(index: 6, trainMenu: [UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!], temp: [60,90,10,10,10,10])//,10,90,60,90,60,90,60,90,60,90])
    static var train2: Train = Train(index: 16, trainMenu: [UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!], temp: [60,90,60,90,60,90,60,90,60,90,60,90,60,90,60,90])
    static var train3: Train = Train(index: 16, trainMenu: [UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!, UIImage(named: "1run")!, UIImage(named: "1.5walk")!,UIImage(named: "1run")!, UIImage(named: "1.5walk")!], temp: [60,90,60,90,60,90,60,90,60,90,60,90,60,90,60,90])
    
    static var train4: Train = Train(index: 12, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!, UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!], temp: [90,120,90,120,90,120,90,120,90,120,90,120])
    
    static var train5: Train = Train(index: 12, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!, UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!], temp: [90,120,90,120,90,120,90,120,90,120,90,120])
    
    static var train6: Train = Train(index: 12, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!, UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!,UIImage(named: "1.5run")!, UIImage(named: "2walk")!], temp: [90,120,90,120,90,120,90,120,90,120,90,120])
    
    static var train7: Train = Train(index: 8, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!, UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!], temp: [90,90,180,180,90,90,180,180])
    
    static var train8: Train = Train(index: 8, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!, UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!], temp: [90,90,180,180,90,90,180,180])
    
    static var train9: Train = Train(index: 8, trainMenu: [UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!, UIImage(named: "1.5run")!, UIImage(named: "1.5walk")!,UIImage(named: "3run")!, UIImage(named: "3walk")!], temp: [90,90,180,180,90,90,180,180])
    
    static var train10: Train = Train(index: 7, trainMenu: [UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!, UIImage(named: "2.5walk")!, UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!], temp: [180,90,300,150,180,90,300])
    static var train11: Train = Train(index: 7, trainMenu: [UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!, UIImage(named: "2.5walk")!, UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!], temp: [180,90,300,150,180,90,300])
    static var train12: Train = Train(index: 7, trainMenu: [UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!, UIImage(named: "2.5walk")!, UIImage(named: "3run")!, UIImage(named: "1.5walk")!,UIImage(named: "5run")!], temp: [180,90,300,150,180,90,300])
    
    static var train13: Train = Train(index: 5, trainMenu: [UIImage(named: "5run")!, UIImage(named: "3walk")!,UIImage(named: "5run")!, UIImage(named: "3walk")!, UIImage(named: "5run")!], temp: [300,180,300,180,300])
    
    static var train14: Train = Train(index: 3, trainMenu: [UIImage(named: "8run")!, UIImage(named: "5walk")!,UIImage(named: "8run")!], temp: [480,300,480])
    
    static var train15: Train = Train(index: 1, trainMenu: [UIImage(named: "21run")!], temp: [1260])
    
    static var train16: Train = Train(index: 5, trainMenu: [UIImage(named: "5run")!, UIImage(named: "3walk")!,UIImage(named: "8run")!, UIImage(named: "3walk")!, UIImage(named: "5run")!], temp: [300,180,480,180,300])
    
    static var train17: Train = Train(index: 3, trainMenu: [UIImage(named: "10run")!, UIImage(named: "3walk")!,UIImage(named: "10run")!], temp: [600,180,600])
    
    static var train18: Train = Train(index: 1, trainMenu: [UIImage(named: "25run")!], temp: [1500])
    
    static var train19: Train = Train(index: 1, trainMenu: [UIImage(named: "25run")!], temp: [1500])
    static var train20: Train = Train(index: 1, trainMenu: [UIImage(named: "25run")!], temp: [1500])
    static var train21: Train = Train(index: 1, trainMenu: [UIImage(named: "28run")!], temp: [1680])
    
    static var train22: Train = Train(index: 1, trainMenu: [UIImage(named: "28run")!], temp: [1680])
    static var train23: Train = Train(index: 1, trainMenu: [UIImage(named: "28run")!], temp: [1680])
    static var train24: Train = Train(index: 1, trainMenu: [UIImage(named: "30run")!], temp: [1800])
    
    static var train25: Train = Train(index: 1, trainMenu: [UIImage(named: "30run")!], temp: [1800])
    static var train26: Train = Train(index: 1, trainMenu: [UIImage(named: "30run")!], temp: [1800])
    static var train27: Train = Train(index: 1, trainMenu: [UIImage(named: "30run")!], temp: [1800])
    
    
    
    static let trains = [
        1: train1, 2: train2, 3: train3,   4: train4, 5: train5,
        6: train6, 7: train7, 8: train8, 9:train9, 10: train10,
        11: train11, 12: train12, 13: train13,   14: train14, 15: train15,
        16: train16, 17: train17, 18: train18, 19:train19, 20: train20,
        21: train21, 22: train22, 23: train23,   24: train24, 25: train25,
        26: train26, 27: train27
    ]
    
    
    
    
}
