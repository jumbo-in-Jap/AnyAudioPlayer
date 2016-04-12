//
//  AnyAudioPlayer.swift
//  audioSample
//
//  Created by HanedaKentarou on 2016/04/12.
//  Copyright © 2016年 Kaumo. All rights reserved.
//

import UIKit
import AVFoundation

protocol AnyAudioPlayerDelegate {
    func finishAudio()
}

class AnyAudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let sharedManager = AnyAudioPlayer()
    var audioPlayer:AVAudioPlayer!
    var avPlayer: AVPlayer!
    var delegate:AnyAudioPlayerDelegate?
    
    // Properties
    
    var nowPlaying:Bool{
        get{
            if audioPlayer != nil && audioPlayer.playing{
                return true
            }
            if avPlayer != nil && avPlayer.rate != 0.0{
                return true
            }
            return false
        }
    }
    
    var duration:NSTimeInterval{
        get{
            if audioPlayer != nil{
                return audioPlayer.duration
            }
            if avPlayer != nil{
                return NSTimeInterval(CMTimeGetSeconds(avPlayer.currentItem!.asset.duration))
            }
            return 0.0
        }
    }

    var currentTime:NSTimeInterval{
        get{
            if audioPlayer != nil{
                return audioPlayer.currentTime
            }
            if avPlayer != nil{
                return NSTimeInterval(CMTimeGetSeconds(avPlayer.currentItem!.currentTime()))
            }
            return 0.0
        }
    }

    // setup
    
    func setUp(){
        // バックグラウンド再生するための設定
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            // エラー処理
            fatalError("カテゴリ設定失敗")
        }
        
        // sessionのアクティブ化
        do {
            try session.setActive(true)
        } catch {
            // audio session有効化失敗時の処理
            // (ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }
    }
    
    func setAudio(url:NSURL){
        
        // stop All Item
        avPlayer = nil
        audioPlayer = nil
        
        // Load Player
        self.loadPlayer(url)
        
    }
    
    func loadPlayer(url:NSURL){
        if url.absoluteString.containsString("http"){
        let playerItem = AVPlayerItem( URL: url )
            avPlayer = AVPlayer(playerItem:playerItem)

        }else{
            audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        }
    }
    
    // Control Audio
    
    func play(){
        if audioPlayer != nil && !audioPlayer.playing{
           audioPlayer.play()
        }
        if avPlayer != nil && avPlayer.rate == 0.0{
            avPlayer.play()
        }
    }
    
    func pause(){
        if audioPlayer != nil && audioPlayer.playing{
            audioPlayer.pause()
        }
        if avPlayer != nil && avPlayer.rate != 0.0{
            avPlayer.pause()
        }
    }
    
    // AVAudioPlayer Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if delegate != nil{
            delegate?.finishAudio()
        }
    }
    
    // AVPlayer Notification
    
    func finishAvPlayerNotification(){
        if delegate != nil{
            delegate?.finishAudio()
        }    
    }
}
