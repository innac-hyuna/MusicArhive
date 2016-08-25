//
//  MusicTableViewCell.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//


import UIKit
import SnapKit

class MusicTableViewCell: UITableViewCell {
    
    var titleLab: UILabel!
    var durationLab: UILabel!
    var iconImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = UIColor.bgSelectedFildColor()
        } else {
            contentView.backgroundColor = UIColor.bgFildColor()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
       
        titleLab = UILabel()
        titleLab.textColor = UIColor.textColor()
        titleLab.font = UIFont.MyTextFont(15)
        contentView.addSubview(titleLab)
        
        durationLab = UILabel()
        durationLab.textColor = UIColor.textColor()
        durationLab.font = UIFont.MyTextFont(15)
        contentView.addSubview(durationLab)
        
        iconImg =  UIImageView()
        contentView.addSubview(iconImg)
        
        setapLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setapLayout() {
        
        iconImg.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(5)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        durationLab.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        titleLab.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(iconImg.snp_right).offset(5)
            make.right.equalTo(durationLab.snp_left).offset(-5)
            make.height.lessThanOrEqualTo(40)
        }
    }
}
