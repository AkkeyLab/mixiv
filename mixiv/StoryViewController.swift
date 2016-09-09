//
//  StoryViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/08.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit
import Material

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var menuView: MenuView!

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

        prepareMenuView()
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

    // ----------     ----------
    /// Handle the menuView touch event.
    internal func handleMenu() {
        if menuView.menu.opened {
            menuView.menu.close()
            (menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
        } else {
            menuView.menu.open() { (v: UIView) in
                (v as? MaterialButton)?.pulse()
            }
            (menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0.125))
        }
    }

    /// Handle the menuView touch event.
    @objc(handleButton:)
    internal func handleButton(button: UIButton) {
        print("Hit Button \(button)")
    }

    /// General preparation statements are placed here.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }

    /// Prepares the MenuView.
    private func prepareMenuView() {
        var image: UIImage? = UIImage(named: "select")?.imageWithRenderingMode(.AlwaysTemplate)
        let btn1: FabButton = FabButton()
        btn1.depth = .None
        btn1.tintColor = MaterialColor.blue.accent3
        btn1.borderColor = MaterialColor.blue.accent3
        btn1.backgroundColor = MaterialColor.white
        btn1.borderWidth = 1
        btn1.setImage(image, forState: .Normal)
        btn1.setImage(image, forState: .Highlighted)
        btn1.addTarget(self, action: #selector(handleMenu), forControlEvents: .TouchUpInside)
        menuView.addSubview(btn1)

        image = UIImage(named: "illust")?.imageWithRenderingMode(.AlwaysTemplate)
        let btn2: FabButton = FabButton()
        btn2.depth = .None
        btn2.tintColor = MaterialColor.blue.accent3
        btn2.pulseColor = MaterialColor.blue.accent3
        btn2.borderColor = MaterialColor.blue.accent3
        btn2.backgroundColor = MaterialColor.white
        btn2.borderWidth = 1
        btn2.setImage(image, forState: .Normal)
        btn2.setImage(image, forState: .Highlighted)
        btn2.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
        menuView.addSubview(btn2)

        // Initialize the menu and setup the configuration options.
        menuView.menu.direction = .Up
        menuView.menu.baseSize = CGSizeMake(55, 55)
        menuView.menu.views = [btn1, btn2]
    }
    // ----------     ----------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
