//
//  PeerListTableViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/17.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class PeerListViewController: UITableViewController {

    var items: [AnyObject]?
    weak var callback: UIViewController?
    // var myTableView:UITableView!

    //
    // required init?(coder aDecoder: NSCoder) {
    // fatalError("init(coder:) has not been implemented")
    // }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = false
        self.navigationItem.title = "Select Target's PeerID"

        let bbiBack: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = bbiBack

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ITEMS")

        self.tableView.delegate = self;
        self.tableView.dataSource = self;

    }

    func cancel() {
        if self.callback != nil {
            self.callback?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let strTo: String = (self.items![indexPath.row] as? String)!
        if self.callback != nil {
            self.callback?.dismissViewControllerAnimated(true, completion: { () -> Void in
                if (self.callback?.respondsToSelector("call:"))! == true {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let view = self.callback as! IllustViewController
                        view.call(strTo)
                    })
                }

//                if (self.callback?.respondsToSelector("connect:"))! == true {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//                        let view = self.callback as! IllustViewController
//                        view.connect(strTo)
//                    })
//
//                }
            })

        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("ITEMS", forIndexPath: indexPath)

        // Cellに値を設定する.
        cell.textLabel!.text = items![indexPath.row] as? String

        return cell
    }
}
