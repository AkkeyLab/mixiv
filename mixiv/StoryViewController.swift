//
//  StoryViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/08.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "StoryTableCell", bundle: nil)
        storyTableView.registerNib(nib, forCellReuseIdentifier: "StoryTableCell")
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.estimatedRowHeight = 20
        storyTableView.rowHeight = UITableViewAutomaticDimension
        storyTableView.separatorStyle = .None
        storyTableView.allowsSelection = false
    }

    // Section num
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Cell num
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    // Select cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! FavoriteTableCellView
    }

    // Make cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = storyTableView.dequeueReusableCellWithIdentifier("StoryTableCell", forIndexPath: indexPath) as! StoryTableCellView
        cell.userIconViewRight.layer.cornerRadius = self.view.frame.size.width / 12
        cell.userIconViewRight.layer.borderColor = UIColor.whiteColor().CGColor
        cell.userIconViewRight.layer.borderWidth = 2
        cell.userIconViewLeft.layer.cornerRadius = self.view.frame.size.width / 12
        cell.userIconViewLeft.layer.borderColor = UIColor.whiteColor().CGColor
        cell.userIconViewLeft.layer.borderWidth = 2
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
