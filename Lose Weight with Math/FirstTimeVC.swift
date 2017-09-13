//
//  FirstTimeVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/24/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


class FirstTimeVC: UIViewController {
    
    @IBOutlet weak var weightTrackerLabel: UILabel!
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    @IBAction func goPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "setupBegin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //self.navigationController?.navigationBar.isHidden = true;
        let theURL = Bundle.main.url(forResource:"appLaunchVideo", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .gray
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstTimeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Weight Tracker
        UIView.animate(withDuration: 5.0, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.weightTrackerLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            
            // Fade in
            UIView.animate(withDuration: 5.0, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.weightTrackerLabel.alpha = 1.0
            }, completion: nil)
        })
        
        
        

    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}

