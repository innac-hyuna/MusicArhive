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
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
       
        titleLab = UILabel()
        contentView.addSubview(titleLab)
        
        durationLab = UILabel()
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
            make.top.equalTo(contentView).offset(5)
            make.left.equalTo(contentView).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        titleLab.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(iconImg.snp_right).offset(5)
            make.right.equalTo(contentView).offset(-5)
            make.height.lessThanOrEqualTo(40)}
        
        durationLab.snp_makeConstraints { (make) in
            make.top.equalTo(titleLab).offset(3)
            make.right.equalTo(contentView).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(10)
        }
    
    }
}
