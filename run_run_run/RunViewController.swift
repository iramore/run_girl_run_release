//
//  RunViewController.swift
//  run_run_run
//
//  Created by infuntis on 29.02.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import SAConfettiView

class RunViewController: UIViewController {
    
    var train: Train?
    var timer = NSTimer()
    let shareData = ShareData.sharedInstance
    var currentStage = 0
    var counter: Float = 0
    var index:Int = 0
    var screenWidth:CGFloat = 0
    var runningMan:[UIImage] = [UIImage(named: "anim_1")!, UIImage(named: "anim_2")!,UIImage(named: "anim_3")!, UIImage(named: "anim_4")!, UIImage(named: "anim_5")!,UIImage(named: "anim_6")!, UIImage(named: "anim_7")!,UIImage(named: "anim_8")!, UIImage(named: "anim_9")!,UIImage(named: "anim_10")!, UIImage(named: "anim_11")!, UIImage(named: "anim_12")!,UIImage(named: "anim_13")!, UIImage(named: "anim_14")! ]
    var walkingMan:[UIImage] = [UIImage(named: "anim_1")!, UIImage(named: "anim_2")!,UIImage(named: "anim_3")!, UIImage(named: "anim_4")!, UIImage(named: "anim_5")!,UIImage(named: "anim_6")!, UIImage(named: "anim_7")!,UIImage(named: "anim_8")!, UIImage(named: "anim_9")!,UIImage(named: "anim_10")!, UIImage(named: "anim_11")!, UIImage(named: "anim_12")!,UIImage(named: "anim_13")!, UIImage(named: "anim_14")! ]
    
    
    func loadTrain() {
        train = Train_data.trains[(shareData.userData?.trainNumber)!]
        counter = train!.temp[0]
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var vxcv: UILabel!
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var image: UIImageView!
    
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerAction", userInfo:nil , repeats: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRectMake(10, 50, 100, 300))
        imageView.tintColor = UIColor.blueColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        print("screen width \(screenWidth)")
        loadTrain()
        image.image = self.getMixedImg(screenSize.width)
        timerLabel.text = "\(counter)"
//        let confettiView = SAConfettiView(frame: self.view.bounds)
//        confettiView.type = .Triangle
//        confettiView.colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
//        self.view.addSubview(confettiView)
//        confettiView.startConfetti()
        let myImage = UIImage(named: "current_stage_background")
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 80))
        myImageView.image = myImage
        vxcv.addSubview(myImageView)
        vxcv.text = "  Run 60 seconds"
        
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func timerAction() {
        --counter
        if(counter < 0 && index < (train?.index)!-1){
            ++index
            counter =  train!.temp[index]
            
        }
        if(counter < 0 && index == (train?.index)!-1){
            timer.invalidate()
            timerLabel.text = "the train is over"
            shareData.increseNumberOfTrains()
            return
        }
        timerLabel.text = "\(counter)"
        updateTrainControlImage()
        
    }

    func updateTrainControlImage(){
        let size = CGSizeMake(screenWidth, 50)
        var imgListArray: [UIImage]  = []
        for var x = 0 ; x < runningMan.count; ++x {
            UIGraphicsBeginImageContext(size)
            var widthVid: CGFloat = 0
            let percent: CGFloat = (CGFloat((train?.temp[index])!-counter))/CGFloat((train?.temp[index])!)
            print(percent)
            if(percent < 1){
                let croppedImage: UIImage = ImageUtil.cropFromLeft(image: (train?.trainMenu[index])!, percent: percent)
                croppedImage.drawInRect(CGRect(x: widthVid, y: 0, width: croppedImage.size.width, height: croppedImage.size.height))
                runningMan[x].drawInRect(CGRect(x: widthVid, y: 0, width: runningMan[x].size.width, height: runningMan[x].size.height))
                widthVid+=croppedImage.size.width
            }
            for var i = self.index+1; i < train?.index; ++i {
                if(widthVid + (train?.trainMenu[i].size.width)! < screenWidth){
                    train?.trainMenu[i].drawInRect(CGRect(x: widthVid, y: 0, width: (train?.trainMenu[i].size.width)!, height: (train?.trainMenu[i].size.height)!))
                    widthVid+=(train?.trainMenu[i].size.width)!
                } else{
                    train?.trainMenu[i].drawInRect(CGRect(x: widthVid, y: 0, width: (train?.trainMenu[i].size.width)!, height: (train?.trainMenu[i].size.height)!))
                    break
                }
                
            }
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imgListArray.append(finalImage)
            //imgListArray[x] = finalImage
        }
        self.image.animationImages = imgListArray
        self.image.animationDuration = 0.3
        self.image.startAnimating()
        //image.image = finalImage
    }
    
    func getMixedImg(width: CGFloat) -> UIImage {
        
        let size = CGSizeMake(width, 50)
        
        UIGraphicsBeginImageContext(size)
        var widthVid: CGFloat = 0
        for im in (train?.trainMenu)!{
            if(widthVid + im.size.width < width){
                im.drawInRect(CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
                widthVid+=im.size.width
            } else{
                im.drawInRect(CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
                break
            }
        }
        
        let finalImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage2
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
