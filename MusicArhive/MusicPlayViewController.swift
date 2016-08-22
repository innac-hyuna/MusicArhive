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
    var urlMusic: String!
    var dataList: [DataMusic]!
    var rowIdA = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = dataList[rowIdA].title
        MusicManager.shared.setAPlayer(urlMusic)
        view.backgroundColor = UIColor.whiteColor()
        buttonPlay = UIButton(type: .Custom) as UIButton
        buttonPlay.tag = 1
        buttonPlay.setImage(UIImage(named:"play"), forState: .Normal)
        buttonPlay.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self]  button in
                let buttonP = button as! UIButton
                if  buttonP.tag == 1{
                    buttonP.setImage(UIImage(named:"pause"), forState: .Normal)
                    buttonP.tag = 0
                    self.setupTimer()
                    MusicManager.shared.play()
                    
                } else {
                    buttonP.setImage(UIImage(named:"play"), forState: .Normal)
                    buttonP.tag = 1
                    MusicManager.shared.pause()
                }
        }
        view.addSubview(buttonPlay)
        
        buttonPre = UIButton(type: .Custom)
        buttonPre.setImage(UIImage(named:"pre"), forState: .Normal)
        buttonPre.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
                    self.rowIdA = self.rowIdA == 0 ? self.dataList.count - 1 : self.rowIdA - 1
                    self.buttonPlay.setImage(UIImage(named:"pause"), forState: .Normal)
                    self.title = self.dataList[self.rowIdA].title
                    MusicManager.shared.setAPlayer(self.dataList[self.rowIdA].urlFile)
                    self.setupTimer()
                    MusicManager.shared.play()
        }
        view.addSubview(buttonPre)
        
        buttonNext = UIButton()
        buttonNext.setImage(UIImage(named: "next"), forState: .Normal)
        buttonNext.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
                self.rowIdA = self.rowIdA == self.dataList.count - 1 ? 0 : self.rowIdA + 1
                self.buttonPlay.setImage(UIImage(named:"pause"), forState: .Normal)
                self.title = self.dataList[self.rowIdA].title
                MusicManager.shared.setAPlayer(self.dataList[self.rowIdA].urlFile)
                self.setupTimer()
                MusicManager.shared.play()
            
        }
        view.addSubview(buttonNext)
        
        buttonRandom = UIButton()
        buttonRandom.setImage(UIImage(named:"random"), forState: .Normal)
        buttonRandom.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
        }
        view.addSubview(buttonRandom)
        
        volumeSlider = UISlider()
        volumeSlider.value = 0.3
        volumeSlider.maximumValue = 1
        volumeSlider.rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { vSlider in
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
    
    func setupTimer() {
        if !MusicManager.shared.audioPlayer.playing {
            self.audioTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MusicPlayViewController.leftTime), userInfo: nil, repeats: true)
            self.timeSlider.maximumValue = MusicManager.shared.getDurataionFloat() }

    }
    override func viewWillDisappear(animated: Bool) {
       var navChild = self.navigationController?.childViewControllers[0]
        (navChild as! MainViewController).rowIdA = self.rowIdA
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
