
//  MusicManager.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/18/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation
import AVFoundation

protocol FinishDelegate {
    func onFinish(result: Bool)
}

class MusicManager: NSObject {
    
    static let shared = MusicManager()   
    var delegate: FinishDelegate?
    var audioPlayer = AVAudioPlayer()
    
    func setAPlayer(urlAll: String)  {
      //  let url = NSURL(fileURLWithPath: urlAll)
     
        do {
        try  audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: urlAll))
        } catch let merror as NSError{
            print(merror) }
        
         audioPlayer.delegate = self
        
    }
    
    func play() {
        dispatch_async(dispatch_get_main_queue(), {
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play() })
    }
    
    func leftTime() -> String {
        return (audioPlayer.duration - audioPlayer.currentTime).strigTime
    }
    
    func getDurataionFloat() -> Float {
        return Float(audioPlayer.duration)
    }
    
    func setTime(val: Float) {
        audioPlayer.currentTime = Double(val)
    }
    
    func setVolume(val: Float) {
        audioPlayer.volume = val
    }
    
    func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    func pause() {
        audioPlayer.pause()
    }    
    
}

extension MusicManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
      self.delegate?.onFinish(true)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {

    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {

    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {

    }
    

}