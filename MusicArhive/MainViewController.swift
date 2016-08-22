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
    let limitRow = 5
    var rowIdA = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Arhive Music"
        
        tableView = UITableView()
        tableView.registerClass(MusicTableViewCell.self, forCellReuseIdentifier: cellIdent)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setupLayout()
        
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Loading..."
        
        JsonDCoreManager.sharedmanager.getData(limitRow) {[unowned self] (resultData) in
            self.arrData = resultData
            if resultData.count == 0 {
                let alererror = UIAlertController(title: "No connect", message: "502", preferredStyle: .Alert)
                alererror.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: { (UIAlertAction) in
                    
                }))
                self.presentViewController(alererror, animated: true, completion: nil)
            }            
            self.tableView.reloadData()
            let indPath = NSIndexPath(forRow: self.rowIdA, inSection: 1)
            self.tableView.selectRowAtIndexPath(indPath, animated: true, scrollPosition: .None)
            self.progressHUD.hideAnimated(true)
        }
    }
    
    func setupLayout() {
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(0)
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
        let urlFile = arrData[indexPath.row].urlFile
         MusicPlay.dataList = arrData
         MusicPlay.rowIdA = indexPath.row
        if urlFile != "" {
            MusicPlay.urlMusic =  arrData[indexPath.row].urlFile
            navigationController?.pushViewController(MusicPlay, animated: true)           
        }
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
            cell.iconImg.kf_setImageWithURL(NSURL(string: arrData[indexPath.row].imageFile))}
        
        return cell
    }
}