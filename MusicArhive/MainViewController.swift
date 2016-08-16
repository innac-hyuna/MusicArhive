//
//  ViewController.swift
//  MusicArhive
//
//  Created by FE Team TV on 8/16/16.
//  Copyright © 2016 courses. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var tableView: UITableView!
    let cellIdent = "MusicCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.registerClass(MusicTableViewCell.self, forCellReuseIdentifier: cellIdent)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
        JsonDCoreManager.sharedmanager.getData { [unowned self] (dBool) in
            if dBool {
              self.tableView.reloadData()
            }
            
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MusicTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdent) as! MusicTableViewCell
        
        return cell
    }


}