//
//  IllustViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/08.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit
import Material
import EPSignature

class IllustViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EPSignatureDelegate {
    @IBOutlet weak var illustTableView: UITableView!
    @IBOutlet weak var menuView: MenuView!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "IllustTableCell", bundle: nil)
        illustTableView.registerNib(nib, forCellReuseIdentifier: "IllustTableCell")
        illustTableView.delegate = self
        illustTableView.dataSource = self
        illustTableView.estimatedRowHeight = 20
        illustTableView.rowHeight = UITableViewAutomaticDimension
        illustTableView.separatorStyle = .None
        illustTableView.allowsSelection = false

        prepareMenuView()
        reloadAnimationSetting()
    }

    func reloadAnimationSetting() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(IllustViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.illustTableView.addSubview(refreshControl)
    }

    func refresh() {
        // ココに更新処理
        refreshControl.endRefreshing() // 更新終了
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
        let cell = illustTableView.dequeueReusableCellWithIdentifier("IllustTableCell", forIndexPath: indexPath) as! IllustTableCellView
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
    func touchButton(sender: UIButton) {
        switch sender.tag {
        case 1:
            makeIllustView()
        case 2:
            callCamera()
        case 3:
            callAlbum()
        default:
            break
        }
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
        btn1.tag = 0
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
        btn2.addTarget(self, action: #selector(IllustViewController.touchButton(_:)), forControlEvents: .TouchUpInside)
        btn2.tag = 1
        menuView.addSubview(btn2)

        image = UIImage(named: "camera")?.imageWithRenderingMode(.AlwaysTemplate)
        let btn3: FabButton = FabButton()
        btn3.depth = .None
        btn3.tintColor = MaterialColor.blue.accent3
        btn3.pulseColor = MaterialColor.blue.accent3
        btn3.borderColor = MaterialColor.blue.accent3
        btn3.backgroundColor = MaterialColor.white
        btn3.borderWidth = 1
        btn3.setImage(image, forState: .Normal)
        btn3.setImage(image, forState: .Highlighted)
        btn3.addTarget(self, action: #selector(IllustViewController.touchButton(_:)), forControlEvents: .TouchUpInside)
        btn3.tag = 2
        menuView.addSubview(btn3)

        image = UIImage(named: "upload")?.imageWithRenderingMode(.AlwaysTemplate)
        let btn4: FabButton = FabButton()
        btn4.depth = .None
        btn4.tintColor = MaterialColor.blue.accent3
        btn4.pulseColor = MaterialColor.blue.accent3
        btn4.borderColor = MaterialColor.blue.accent3
        btn4.backgroundColor = MaterialColor.white
        btn4.borderWidth = 1
        btn4.setImage(image, forState: .Normal)
        btn4.setImage(image, forState: .Highlighted)
        btn4.addTarget(self, action: #selector(IllustViewController.touchButton(_:)), forControlEvents: .TouchUpInside)
        btn4.tag = 3
        menuView.addSubview(btn4)

        // Initialize the menu and setup the configuration options.
        menuView.menu.direction = .Up
        menuView.menu.baseSize = CGSizeMake(55, 55)
        menuView.menu.views = [btn1, btn2, btn3, btn4]
    }
    // ----------     ----------

    func makeIllustView() {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
        signatureVC.subtitleText = "イラストで今日の思い出を残そう！"
        signatureVC.title = "イラスト"
        let nav = UINavigationController(rootViewController: signatureVC)
        presentViewController(nav, animated: true, completion: nil)
    }

    func epSignature(_: EPSignatureViewController, didCancel error: NSError) {
        print("User canceled")
    }

    func epSignature(_: EPSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        print(signatureImage)
//        imgViewSignature.image = signatureImage
    }

    func callCamera() { // #360
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let ip = UIImagePickerController()
            ip.sourceType = UIImagePickerControllerSourceType.Camera
            ip.allowsEditing = false
            self.presentViewController(ip, animated: true, completion: nil)
        }
    }

    func callAlbum() { // #380
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let ip = UIImagePickerController()
            ip.delegate = self
            ip.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(ip, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print(image)
            NSLog("get image")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
