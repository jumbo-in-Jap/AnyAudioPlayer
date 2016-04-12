//
//  ViewController.swift
//  audioSample
//
//  Created by HanedaKentarou on 2016/04/12.
//  Copyright © 2016年 Kaumo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AnyAudioPlayerDelegate {
    
    @IBOutlet weak var avButton: UIButton!
    @IBOutlet weak var avAudioButton: UIButton!
    var playIndex = 0
    var contentPaths = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localAudioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mondo_01", ofType: "mp3")!)
        let streamingUrlPath = NSURL(string:"http://a768.phobos.apple.com/us/r20/Music/v4/f4/91/e1/f491e16b-f615-cb85-a26b-c6924b90b789/mzaf_6988773463780401999.aac.m4a")!
        
        contentPaths = [localAudioPath, streamingUrlPath, localAudioPath]
        AnyAudioPlayer.sharedManager.setAudio(contentPaths[playIndex])

    }
    
    @IBAction func play(sender : AnyObject) {
        
        if ( AnyAudioPlayer.sharedManager.nowPlaying ){
            AnyAudioPlayer.sharedManager.pause()
        }
        else{
            AnyAudioPlayer.sharedManager.play()
        }
    }
    
    @IBAction func next(sender: AnyObject){
        if contentPaths.count == playIndex{
            return
        }
        playIndex += 1
        
        let contentUrl = contentPaths[playIndex]
        AnyAudioPlayer.sharedManager.setAudio(contentUrl)
        AnyAudioPlayer.sharedManager.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func finishAudio(){
        print("Finish Play")
    }
}

