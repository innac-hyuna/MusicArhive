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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Arhive Music"
        
        MusicManager.shared.delegateChage = self
        
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
                 self.viewDidLoad()
                }))
                self.presentViewController(alererror, animated: true, completion: nil)
            }            
            self.tableView.reloadData()
            self.progressHUD.hideAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func setupLayout() {
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       
         let MusicPlay = MusicPlayViewController()
         MusicPlay.dataList = arrData
         MusicPlay.rowIdA = indexPath.row
         navigationController?.pushViewController(MusicPlay, animated: true)
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
            cell.iconImg.kf_setImageWithURL(NSURL(string: arrData[indexPath.row].imageFile))
            cell.durationLab.text =  arrData[indexPath.row].duration
        }
        return cell
    }
}

extension MainViewController: MusicMainDelegate {
    
    func didCangeRow(row: Int) {
        (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: MusicManager.shared.rowIdA, inSection: 0)) as? MusicTableViewCell)?.durationLab.text = ""
        let indexR =  NSIndexPath(forRow: row, inSection: 0)
        tableView.selectRowAtIndexPath(indexR, animated: false, scrollPosition: .None)
    }
    
    func didTime(time: String){
        (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: MusicManager.shared.rowIdA, inSection: 0)) as? MusicTableViewCell)?.durationLab.text = time
    }  
}