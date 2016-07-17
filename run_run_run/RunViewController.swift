

import UIKit
import SAConfettiView

class RunViewController: UIViewController {
    @IBOutlet weak var smallCounterView: CounterView!
    @IBOutlet weak var bigCounterView: CounterView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bigTimer: UILabel!
    @IBOutlet weak var smallTimer: UILabel!
    
    @IBOutlet weak var runner: UIImageView!
    
    
    @IBOutlet weak var vxcv: UILabel!
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var image: UIImageView!
    
    
    var timerSmall = NSTimer()
    var train: Train = Train_data.trains[(ShareData.sharedInstance.userData?.trainNumber)!]!
    var currentStage = 0
    var counter: Int = 0
    var counterBig: Int = 0
    var index:Int = 0
    var screenWidth:CGFloat = 0
    var runningMan:[UIImage] = [UIImage(named: "rrrr1")!, UIImage(named: "rrrr2")!]
    var isStarted:Bool = false
    var imagePos: CGFloat = 0
    var isRunning: Bool = true
    var sticker: UIImageView?
    
    
    func loadTrain() {
        counter = train.temp[0]
        counter *= 100
        let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000,(counter/100)%60, counter%100)
        smallTimer.text = str as String
        let str2 = NSString(format:"%0.2d:%0.2d", counterBig/60,counterBig%60)
        bigTimer.text = str2 as String
        smallCounterView.maxValue = counter
        let value = train.temp.reduce(0, combine: +)
        bigCounterView.maxValue = value
        let firstImage: CGSize = train.trainMenu[0].size
        imagePos = firstImage.width
    }
    
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        if(!isStarted){
            timerSmall.invalidate()
            timerSmall = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(RunViewController.timerActionSmall), userInfo:nil ,   repeats: true)
            startButton.setTitle("PAUSE", forState: .Normal)
            self.runner.animationImages = runningMan
            self.runner.animationDuration = 0.5
            self.runner.startAnimating()
            isStarted = true
        } else{
            timerSmall.invalidate()
            startButton.setTitle("START", forState: .Normal)
            isStarted = false
            self.runner.stopAnimating()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        loadTrain()
        self.image.image = self.getMixedImg(screenSize.width)
        let myImage = UIImage(named: "current_stage_background")
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 80))
        myImageView.image = myImage
        vxcv.addSubview(myImageView)
        vxcv.text = "  Run 60 seconds"
        self.runner.contentMode = .ScaleAspectFit
        self.runner.image = UIImage(named: "rrrr1")!
        
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func timerActionSmall() {
        counter-=5
        if(counter%100 == 0){
            counterBig+=1
            bigCounterView.counter = counterBig
            let str = NSString(format:"%0.2d:%0.2d", counterBig/60, counterBig%60)
            bigTimer.text = str as String
            updateTrainControlImage()
        }
        if(counter < 0){
            if(index < (train.index)-1){
                isRunning = !isRunning
                index+=1
                counter =  train.temp[index]*100
                let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000, (counter/100)%60, counter%100)
                smallTimer.text = str as String
                smallCounterView.counter = 0
                smallCounterView.maxValue = counter
                return
            }
            if(index == (train.index)-1){
                timerSmall.invalidate()
                ShareData.sharedInstance.increseNumberOfTrains()
                vxcv.text = " The training is over "
                return
            }
        }
        let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000, (counter/100)%60, counter%100)
        smallTimer.text = str as String
        smallCounterView.counter = train.temp[index]*100-counter
        
    }
    
    func updateTrainControlImage(){
        let size = CGSizeMake(screenWidth, 50)
        UIGraphicsBeginImageContext(size)
        var widthVid: CGFloat = 0
        let percent: CGFloat = (CGFloat((train.temp[index])*100-counter))/CGFloat((train.temp[index]*100))
        if(percent < 1){
            let croppedImage: UIImage = ImageUtil.cropFromLeft(image: (train.trainMenu[index]), percent: percent)
            croppedImage.drawInRect(CGRect(x: widthVid, y: 0, width: croppedImage.size.width, height: croppedImage.size.height))
            widthVid+=croppedImage.size.width
        }
        let startedPositonForStiker = widthVid
        for i in self.index+1 ..< train.index {
            if(widthVid + train.trainMenu[i].size.width < screenWidth){
                train.trainMenu[i].drawInRect(CGRect(x: widthVid, y: 0, width: train.trainMenu[i].size.width, height: train.trainMenu[i].size.height))
                widthVid+=train.trainMenu[i].size.width
            } else{
                train.trainMenu[i].drawInRect(CGRect(x: widthVid, y: 0, width: train.trainMenu[i].size.width, height: train.trainMenu[i].size.height))
                break
            }
            
        }
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if(index == (train.index)-1){
            self.sticker!.image = UIImage(named: "white")!
        }
        else{
            if(isRunning){
                self.sticker!.image = UIImage(named: "1.5walk")!
            } else{
                self.sticker!.image = UIImage(named: "1run")!
            }
        }
        self.image.image = finalImage
        var frame:CGRect = self.sticker!.frame
        frame.origin.x = startedPositonForStiker
        self.sticker!.frame = frame
        
    }
    
    func getMixedImg(width: CGFloat) -> UIImage {
        let size = CGSizeMake(width, 50)
        UIGraphicsBeginImageContext(size)
        var widthVid: CGFloat = 0
        for im in train.trainMenu {
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
        let imageName = "1.5walk"
        let image = UIImage(named: imageName)
        sticker = UIImageView(image: image!)
        let y = self.image.frame.origin.y
        sticker!.frame = CGRect(x: imagePos, y: y, width: 50, height: 50)
        self.view.addSubview(sticker!)
        return finalImage2
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
