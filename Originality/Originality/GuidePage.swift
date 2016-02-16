//
//  GuidePage.swift
//  Originality
//
//  Created by suze on 16/1/1.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit
import AVFoundation

class GuidePage: FXBasePage {
    @IBOutlet var backImageView:UIImageView?
    
    var player:AVPlayer!
    var playItem:AVPlayerItem!
    var location:FxLocation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initPlayVideo()
        doAnimation()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func doAnimation()
    {
        print("animation")
        var images:[UIImage]=[]
        var image:UIImage?
        var imageName:String?
        
        for var index=0; index<=67;index++ {
            imageName = "logo-" + String(format: "%03d.png", index)
            image = UIImage(named: imageName!)
            images.insert(image!, atIndex: index)
        }
        
        
        backImageView?.animationImages = images
        backImageView?.animationRepeatCount = 1
        backImageView?.animationDuration = 5
        
        
        backImageView?.startAnimating()
        
        UIView.animateWithDuration(0.7, delay: 4, options: .CurveEaseOut, animations: { () -> Void in
            self.backView!.alpha = 1.0
            self.player.play()
            },completion:{
                finished in
                print("Animation End")
                })
    }
    
    
    func initPlayVideo()
    {
        let path = NSBundle.mainBundle().pathForResource("welcome_video", ofType: "mp4")
        let url = NSURL.fileURLWithPath(path!)
        
        
        playItem = AVPlayerItem(URL: url)
        player = AVPlayer(playerItem: playItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.backView!.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        backView!.layer.insertSublayer(playerLayer, atIndex:0)
        
        backView?.alpha = 0.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishVideo:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playItem)
    }
  
    func didFinishVideo(sender:NSNotification)
    {
        let item = sender.object as! AVPlayerItem
        
        item.seekToTime(kCMTimeZero)
        
        self.player?.play()
    }
    
    
    
    @IBAction func doLogin()
    {
        location = FxLocation()
        location.startLocation()
    }
    @IBAction func doRegister()
    {
       let page = CreatAccountPage()
       let navPage = UINavigationController(rootViewController: page)
        
       self.presentViewController(navPage, animated: true, completion: nil)
        
    }
}
