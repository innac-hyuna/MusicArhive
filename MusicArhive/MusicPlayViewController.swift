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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        buttonPlay = UIButton(type: .Custom) as UIButton
        buttonPlay.setImage(UIImage(named:"play"), forState: .Normal)
        buttonPlay.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self]  _ in
            
        }
        view.addSubview(buttonPlay)
        
        buttonPre = UIButton(type: .Custom)
        buttonPre.enabled = false
        buttonPre.setImage(UIImage(named:"pre"), forState: .Normal)
        buttonPre.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
            
        }
        view.addSubview(buttonPre)
        
        buttonNext = UIButton()
        buttonNext.enabled = false
        buttonNext.setImage(UIImage(named: "next"), forState: .Normal)
        buttonNext.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
            
        }
        view.addSubview(buttonNext)
        
        buttonRandom = UIButton()
        buttonRandom.setImage(UIImage(named:"random"), forState: .Normal)
        buttonRandom.rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { [unowned self] _ in
        }
        view.addSubview(buttonRandom)
        
        volumeSlider = UISlider()
        volumeSlider.enabled = false
        volumeSlider.value = 0.3
        volumeSlider.rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { [unowned self] _ in
            
        }
        view.addSubview(volumeSlider)
        
        timeSlider = UISlider()
        timeSlider.enabled = false
        timeSlider.value = 0.3
        timeSlider.rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { [unowned self] _ in
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
    
    func setupLayout() {
        
        buttonPre.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideTop).offset(25)
            make.left.equalTo(view).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonPlay.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideTop).offset(25)
            make.left.equalTo(buttonPre.snp_right).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonNext.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideTop).offset(25)
            make.left.equalTo(buttonPlay.snp_right).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        buttonRandom.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideTop).offset(25)
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
