//
//  ViewController.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    var tableView: UITableView!
    let cellIdent = "MusicCell"
    var arrData: [DataMusic]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.registerClass(MusicTableViewCell.self, forCellReuseIdentifier: cellIdent)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setuoLayout()
        
        JsonDCoreManager.sharedmanager.getData {[unowned self] (resultData) in
            self.arrData = resultData
            self.tableView.reloadData()
        }
        
    }
    
    func setuoLayout() {
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideTop).offset(5)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDelegate {

}

extension MainViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData != nil ? arrData.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MusicTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdent) as! MusicTableViewCell
        if arrData != nil {
            cell.titleLab.text = arrData[indexPath.row].title
            cell.iconImg.kf_setImageWithURL(NSURL(string: arrData[indexPath.row].image_file))}        
        
        return cell
    }


}