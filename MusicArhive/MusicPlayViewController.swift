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
    var imagIcon: UIImageView!
    var volUser: Float!
    var dataList: [DataMusic]!
    var rowIdA = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.bgFildColor()
        
        let defaultUser = NSUserDefaults()
        volUser = defaultUser.floatForKey("volumeUser")
        
        title = dataList[rowIdA].title
        
        MusicManager.shared.delegateFinish = self
        
        imagIcon = UIImageView()
        imagIcon.kf_setImageWithURL(NSURL(string: dataList[rowIdA].imageFile))
        view.addSubview(imagIcon)
        
        buttonPlay = UIButton(type: .Custom) as UIButton
        buttonPlay.setImage(UIImage(named:"play"), forState: .Normal)
        let playSignal = buttonPlay.rac_signalForControlEvents(.TouchUpInside)
            playSignal.subscribeNext { [unowned self]  button in
                
                if !MusicManager.shared.audioPlayer.playing {
                   self.play()
                } else {
                   MusicManager.shared.pause()
                   self.setPlayButton()
                }
        }
        view.addSubview(buttonPlay)
        
        buttonPre = UIButton(type: .Custom)
        buttonPre.setImage(UIImage(named:"pre"), forState: .Normal)
        let preSiganl = buttonPre.rac_signalForControlEvents(.TouchUpInside)
            preSiganl.subscribeNext { [unowned self]  _ in
             MusicManager.shared.listPrew()
             self.play()
        }
        view.addSubview(buttonPre)
        
        buttonNext = UIButton()
        buttonNext.setImage(UIImage(named: "next"), forState: .Normal)
        let nextSugnal = buttonNext.rac_signalForControlEvents(.TouchUpInside)
            nextSugnal.subscribeNext {[unowned self] _ in
             MusicManager.shared.listNext()
             self.play()
        }
        view.addSubview(buttonNext)
        
        buttonRandom = UIButton()
        buttonRandom.tag = defaultUser.integerForKey("tagUser")
        buttonRandom.setImage(UIImage(named: buttonRandom.tag == 0 ? "random" : "listplay"), forState: .Normal)
        buttonRandom.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { button in
                let buttonRa = button as! UIButton
                buttonRa.tag =  buttonRa.tag == 0 ? 1 : 0
                buttonRa.setImage(UIImage(named:  buttonRa.tag == 0 ? "random" : "listplay"), forState: .Normal)               
                defaultUser.setInteger(buttonRa.tag, forKey: "tagUser")
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
        
        
        if MusicManager.shared.dataList == nil ||  MusicManager.shared.rowIdA != rowIdA {
            MusicManager.shared.setAPlayer(dataList, row: rowIdA)
        } else {
            play() }
       
        
        setupLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlayButton() {
         buttonPlay.setImage(UIImage(named: "play"), forState: .Normal)
    }
    
    func setPauseButton() {
         buttonPlay.setImage(UIImage(named: "pause"), forState: .Normal)
    }
    
    func play() {
         timer()
         MusicManager.shared.play()
    }
    func timer() {        
        timeSlider.value = Float(MusicManager.shared.audioPlayer.currentTime)
        timeSlider.maximumValue = MusicManager.shared.getDurataionFloat()
        self.setPauseButton()
        title = dataList[MusicManager.shared.rowIdA].title
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
        
        imagIcon.snp_makeConstraints { (make) in
            make.top.equalTo(timeSlider.snp_bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view.snp_right).offset(-10)
            make.bottom.equalTo(view.snp_bottom).offset(-10)
         }
    }
}

extension MusicPlayViewController : MusicDelegate  {
    
    func onFinish(result: Bool) {
        timer() 
    }
    
    func didTime(time: String) {
        timeLabel.text = time
        imagIcon.kf_setImageWithURL(NSURL(string: dataList[MusicManager.shared.rowIdA].imageFile))
        timeSlider.value = Float(MusicManager.shared.audioPlayer.currentTime)
    }

}
