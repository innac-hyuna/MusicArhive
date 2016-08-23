//
//  MusicPlayViewController.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/18/16.
//  Copyright © 2016 courses. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa

protocol ChangeIdRow: class {
    func didCangeRow(row: Int)
}

struct RowStuct {
    static var delegate: ChangeIdRow!
    static func cangeRow(rowId: Int) {
        delegate.didCangeRow(rowId)
    }
}


class MusicPlayViewController: UIViewController {
    
    var buttonPlay: UIButton!
    var buttonPre: UIButton!
    var buttonNext: UIButton!
    var buttonRandom: UIButton!
    var volumeSlider: UISlider!
    var timeSlider: UISlider!
    var timeLabel: UILabel!
    var audioTimer: NSTimer!
    var imagIcon: UIImageView!
    var volUser: Float!
    var dataList: [DataMusic]!
    var rowIdA = 0
    static  var delegate: ChangeIdRow!
    var tagPlay: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaultUser = NSUserDefaults()
        volUser = defaultUser.floatForKey("volumeUser")
        tagPlay = defaultUser.integerForKey("volumeUser")
        
        title = dataList[rowIdA].title
        
        MusicManager.shared.setAPlayer(dataList[rowIdA].urlFile)
        
        MusicManager.shared.delegate = self
        
        view.backgroundColor = UIColor.whiteColor()
        
        buttonPlay = UIButton(type: .Custom) as UIButton
        buttonPlay.tag = 0
        buttonPlay.setImage(UIImage(named:"play"), forState: .Normal)
        buttonPlay.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { button in
                let buttonPl = button as! UIButton
                if buttonPl.tag == 0 {
                    self.setupTimerPlay()
                } else {
                    MusicManager.shared.pause()
                   self.setPlayButton()
                   }
        }
        view.addSubview(buttonPlay)
        
        buttonPre = UIButton(type: .Custom)
        buttonPre.setImage(UIImage(named:"pre"), forState: .Normal)
        buttonPre.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
                self.activRow(self.rowIdA == 0 ? self.dataList.count - 1 : self.rowIdA - 1)
                self.title = self.dataList[self.rowIdA].title
                MusicManager.shared.setAPlayer(self.dataList[self.rowIdA].urlFile)
                self.setupTimerPlay()
               
        }
        view.addSubview(buttonPre)
        
        buttonNext = UIButton()
        buttonNext.setImage(UIImage(named: "next"), forState: .Normal)
        buttonNext.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
                self.listPlayNext()
        }
        view.addSubview(buttonNext)
        
        buttonRandom = UIButton()
        buttonRandom.tag = tagPlay
        buttonRandom.setImage(UIImage(named: tagPlay == 0 ? "random" : "listplay"), forState: .Normal)
        buttonRandom.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] button in
                let buttonRa = button as! UIButton
                buttonRa.tag = self.tagPlay
                buttonRa.setImage(UIImage(named:  button.tag == 0 ? "random" : "listplay"), forState: .Normal)
                defaultUser.setInteger(self.tagPlay, forKey: "volumeUser")
                self.setupTimerPlay()
               
        }
        
        view.addSubview(buttonRandom)
        
        volumeSlider = UISlider()
        volumeSlider.value = volUser
        volumeSlider.maximumValue = 1
        volumeSlider.rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { vSlider in
            let defaultUser = NSUserDefaults()
             defaultUser.setFloat(vSlider.value, forKey: "volumeUser")
             MusicManager.shared.setVolume(vSlider.value)
        }
        
        view.addSubview(volumeSlider)
       
        timeSlider = UISlider()
        timeSlider.value = 0
        timeSlider.rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { tSlider in
                MusicManager.shared.setTime(tSlider.value)
        }
        view.addSubview(timeSlider)
        
        timeLabel = UILabel()
        view.addSubview(timeLabel)
       
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func activRow(rowId: Int) {
        self.rowIdA = rowId
        RowStuct.cangeRow(rowId)
    }
    
    func setPlayButton() {
        buttonPlay.setImage(UIImage(named: "play"), forState: .Normal)
        buttonPlay.tag = 0
    }
    
    func setPauseButton() {
        buttonPlay.setImage(UIImage(named: "pause"), forState: .Normal)
        buttonPlay.tag = 1
    }
    
    func randomPlay() {
        activRow((dataList.count - 1).randomNumber())
        title = dataList[rowIdA].title
        MusicManager.shared.setAPlayer(dataList[rowIdA].urlFile)
        setupTimerPlay()
       
        
    }
    
    func listPlayNext() {
        activRow(rowIdA == dataList.count - 1 ? 0 : rowIdA + 1)
        title = dataList[rowIdA].title
        MusicManager.shared.setAPlayer(dataList[rowIdA].urlFile)
        
        
    }
    
    func setupTimerPlay() {
        if !MusicManager.shared.audioPlayer.playing {
            self.audioTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MusicPlayViewController.leftTime), userInfo: nil, repeats: true)
            self.timeSlider.maximumValue = MusicManager.shared.getDurataionFloat()
         MusicManager.shared.play()
         setPauseButton()}
    }
    
    func leftTime() {
        timeLabel.text = MusicManager.shared.leftTime()
        timeSlider.value = Float(MusicManager.shared.audioPlayer.currentTime)
    }
    
    func setupLayout() {
        
        buttonPre.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(25)
            make.left.equalTo(view).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonPlay.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(25)
            make.left.equalTo(buttonPre.snp_right).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonNext.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(25)
            make.left.equalTo(buttonPlay.snp_right).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonRandom.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(25)
            make.right.equalTo(view.snp_right).offset(-10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        volumeSlider.snp_makeConstraints { (make) in
            make.top.equalTo(buttonPre.snp_bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(buttonPlay.snp_bottom).offset(10)
            make.left.equalTo(volumeSlider.snp_right).offset(10)
            make.width.lessThanOrEqualTo(view).offset(-10)
            make.height.equalTo(44)
        }
        timeSlider.snp_makeConstraints { (make) in
            make.top.equalTo(buttonPre.snp_bottom).offset(10)
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.right.equalTo(view.snp_right).offset(-10)
            make.height.equalTo(44)
        }
    }
}

extension MusicPlayViewController : FinishDelegate {
    
    func onFinish(result: Bool) {
        buttonRandom.tag == 0 ? randomPlay() : listPlayNext()
    }
}
