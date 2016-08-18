//
//  ViewController.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class MainViewController: UIViewController {
    var tableView: UITableView!
    let cellIdent = "MusicCell"
    var arrData: [DataMusic]!
    var progressHUD: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.registerClass(MusicTableViewCell.self, forCellReuseIdentifier: cellIdent)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setuoLayout()
        
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Loading..."
        
        JsonDCoreManager.sharedmanager.getData {[unowned self] (resultData) in
            self.arrData = resultData
            if resultData.first!.id == "0" {
                let alererror = UIAlertController(title: "No connect", message: "502", preferredStyle: .Alert)
                alererror.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: { (UIAlertAction) in
                    
                }))
                self.presentViewController(alererror, animated: true, completion: nil)
            }            
            self.tableView.reloadData()
            self.progressHUD.hideAnimated(true)
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let MusicPlay = MusicPlayViewController()
        presentViewController(MusicPlay, animated: true, completion: nil)
    }
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