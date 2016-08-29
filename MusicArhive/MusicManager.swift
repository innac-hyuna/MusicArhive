
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
    var dataList: [DataMusic]!
    var audioTimer: NSTimer!
    var rowIdA: Int!
    
    func setAPlayer(data: [DataMusic]? , row: Int?)  {
        dataList = data != nil ? data : dataList
        rowIdA = row != nil ? row : rowIdA
        setUrlToAudioPlayer()
    }
    
    func setUrlToAudioPlayer() {
        do {
            try  audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: dataList[rowIdA].urlFile))
        } catch let merror as NSError{
            print(merror) }
        audioTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MusicManager.lTime), userInfo: nil, repeats: true)
        audioPlayer.delegate = self       
    }
    
    func play() {
        dispatch_async(dispatch_get_main_queue(), {
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play() })
    }
    
    func lTime()  {
        NSNotificationCenter.defaultCenter().postNotificationName("NTimer", object: (audioPlayer.duration - audioPlayer.currentTime).strigTime)
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
    
    func listNext() {
       activRow(rowIdA == dataList.count - 1 ? 0 : rowIdA + 1)
       setUrlToAudioPlayer()
    }
    
    func listPrew() {
       activRow(self.rowIdA == 0 ? self.dataList.count - 1 : self.rowIdA - 1)
       setUrlToAudioPlayer()     
    }
    
    func randomPlay() {
        activRow((dataList.count - 1).randomNumber())
        setUrlToAudioPlayer()      
    }  
    
    func activRow(rowId: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("NRowCahge", object: rowId)
        self.rowIdA = rowId
    }
}

//MARK: AVAudioPlayerDelegate

extension MusicManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {     
        let defaultUser = NSUserDefaults()
        defaultUser.integerForKey("tagUser") == 0 ? randomPlay() : listNext()
        play()
        NSNotificationCenter.defaultCenter().postNotificationName("NFinish", object: (true))
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {

    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {

    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {

    }

}