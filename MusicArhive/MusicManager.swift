//
//  MusicManager.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/18/16.
//  Copyright © 2016 courses. All rights reserved.
//

import Foundation
import AVFoundation

class MusicManager: NSObject {
    
    static let shared = MusicManager()
    var audioPlayer = AVAudioPlayer()
    
    func setAPlayer(url: NSURL)  {
        do {
        try  audioPlayer = AVAudioPlayer(contentsOfURL: url)
             audioPlayer.delegate = self
        } catch let merror as NSError{
            print(merror) }
    }
    
    func play() {
        
    }
    
    func playRandom() {
        
    }
    
}

extension MusicManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {

    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {

    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {

    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {

    }
    

}