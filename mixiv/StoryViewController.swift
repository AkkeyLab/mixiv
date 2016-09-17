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
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var editMessageTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!

    private var refreshControl: UIRefreshControl!
    private var _peer: SKWPeer?
    private var _data: SKWDataConnection?
    private var _id: String? = nil
    private var _bEstablished: Bool = false
    private var _listPeerIds: Array<String> = []

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
        reloadAnimationSetting()
        webRTC()
    }

    func reloadAnimationSetting() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(StoryViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.storyTableView.addSubview(refreshControl)
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
    func touchButton(sender: UIButton) {
        switch sender.tag {
        case 1:
            callEditStory()
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
        btn2.addTarget(self, action: #selector(StoryViewController.touchButton(_:)), forControlEvents: .TouchUpInside)
        btn2.tag = 1
        menuView.addSubview(btn2)

        // Initialize the menu and setup the configuration options.
        menuView.menu.direction = .Up
        menuView.menu.baseSize = CGSizeMake(55, 55)
        menuView.menu.views = [btn1, btn2]
    }
    // ----------     ----------

    func callEditStory() {
        let storyboard: UIStoryboard = UIStoryboard(name: "EditStory", bundle: NSBundle.mainBundle())
        let editStoryViewController: EditStoryViewController = storyboard.instantiateInitialViewController() as! EditStoryViewController

        self.navigationController?.pushViewController(editStoryViewController, animated: true)
    }

    // ---------- NTT Communications ----------
    func webRTC() {
        let option: SKWPeerOption = SKWPeerOption.init()
        option.key = "ae7068ea-8871-45c3-b157-23be59c73d5f"
        option.domain = "akkeylab"
        _peer = SKWPeer.init(options: option)

        _peer?.on(SKWPeerEventEnum.PEER_EVENT_ERROR, callback: { (obj: NSObject!) -> Void in
            let error: SKWPeerError = obj as! SKWPeerError
            print("\(error)")
        })

        _peer?.on(SKWPeerEventEnum.PEER_EVENT_OPEN, callback: { (obj: NSObject!) -> Void in
            self._id = obj as? String
            dispatch_async(dispatch_get_main_queue(), {
                self.idLabel.text = "チャットID： \n\(self._id!)"
            })
        })

        _peer?.on(SKWPeerEventEnum.PEER_EVENT_CONNECTION, callback: { (obj: NSObject!) -> Void in
            self._data = obj as? SKWDataConnection
            self.setDataCallbacks(self._data!)
            self._bEstablished = true
            self.updateUI()
        })
    }

    func setDataCallbacks(data: SKWDataConnection) {

        data.on(SKWDataConnectionEventEnum.DATACONNECTION_EVENT_OPEN, callback: { (obj: NSObject!) -> Void in
            self.appendLogWithHead("system", value: "DataConnection opened")
            self._bEstablished = true;
            self.updateUI();
        })

        data.on(SKWDataConnectionEventEnum.DATACONNECTION_EVENT_DATA, callback: { (obj: NSObject!) -> Void in
            let strValue: String = obj as! String
            self.appendLogWithHead("Partner", value: strValue)

        })

        data.on(SKWDataConnectionEventEnum.DATACONNECTION_EVENT_CLOSE, callback: { (obj: NSObject!) -> Void in
            self._data = nil
            self._bEstablished = false
            self.updateUI()
            self.appendLogWithHead("system", value: "DataConnection closed.")
        })
    }

    func getPeerList() {
        if (_peer == nil) || (_id == nil) || (_id?.characters.count == 0) {
            return
        }

        _peer?.listAllPeers({ (peers: [AnyObject]!) -> Void in
            self._listPeerIds = []
            let peersArray: [String] = peers as! [String]
            for strValue: String in peersArray {
                print(strValue)

                if strValue == self._id {
                    continue
                }
                self._listPeerIds.append(strValue)
            }
            if self._listPeerIds.count > 0 {
                self.showPeerDialog()
            }
        })
    }

    func connect(strDestId: String) {
        let options = SKWConnectOption()
        options.label = "chat"
        options.metadata = "{'message': 'hi'}"
        options.serialization = SKWSerializationEnum.SERIALIZATION_BINARY
        options.reliable = true

        _data = _peer?.connectWithId(strDestId, options: options)
        setDataCallbacks(self._data!)
        self.updateUI()
    }

    func close() {
        if _bEstablished == false {
            return
        }
        _bEstablished = false

        if _data != nil {
            _data?.close()
        }
    }

    func send(data: String) {
        let bResult: Bool = (_data?.send(data))!

        if bResult == true {
            self.appendLogWithHead("You", value: data)
        }
    }

    func showPeerDialog() {
        let vc: PeerListForDataViewController = PeerListForDataViewController()
        vc.items = _listPeerIds
        vc.callback = self

        let nc: UINavigationController = UINavigationController.init(rootViewController: vc)

        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(nc, animated: true, completion: nil)
        })

    }

    func updateUI() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            if self._bEstablished == false {
                self.callButton.setTitle("CALL", forState: UIControlState.Normal)
            } else {
                self.callButton.setTitle("DISCONNECT", forState: UIControlState.Normal)
            }

            if self.idLabel == nil {
                self.idLabel.text = "チャットID："
            } else {
                self.idLabel.text = "チャットID：" + self._id! as String
            }

            self.sendButton.enabled = self._bEstablished
        }
    }

    @IBAction func pushCallButton(sender: AnyObject) {
        if _data == nil {
            self.getPeerList()
        } else {
            self.performSelectorInBackground(#selector(StoryViewController.close), withObject: nil)
        }
    }

    @IBAction func pushSendButton(sender: AnyObject) {
        let data: String = self.editMessageTextField.text!;
        self.send(data)
        self.editMessageTextField.text = ""
    }

    func appendLogWithMessage(strMessage: String) {
        var rng = NSMakeRange((logTextView.text?.characters.count)! + 1, 0)
        logTextView.selectedRange = rng
        logTextView.replaceRange(logTextView.selectedTextRange!, withText: strMessage)
        rng = NSMakeRange(logTextView.text.characters.count + 1, 0)
        logTextView.scrollRangeToVisible(rng)

    }

    func appendLogWithHead(strHeader: String?, value strValue: String) {
        if 0 == strValue.characters.count {
            return
        }
        let mstrValue = NSMutableString()
        if nil != strHeader {
            mstrValue.appendString("[")
            mstrValue.appendString(strHeader!)
            mstrValue.appendString("] ")
        }
        if 32000 < strValue.characters.count {
            // var rng:NSRange = NSMakeRange(0, 32)
            mstrValue.appendString(strValue.substringWithRange(Range<String.Index>(start: strValue.startIndex.advancedBy(0), end: strValue.startIndex.advancedBy(32))))
            mstrValue.appendString("...")
            // rng = NSMakeRange(strValue.characters.count - 32, 32)
            mstrValue.appendString(strValue.substringWithRange(Range<String.Index>(start: strValue.startIndex.advancedBy(strValue.characters.count - 32), end: strValue.startIndex.advancedBy(32))))
        } else {
            mstrValue.appendString(strValue)
        }
        mstrValue.appendString("\n")
        self.performSelectorOnMainThread(#selector(StoryViewController.appendLogWithMessage(_:)), withObject: mstrValue, waitUntilDone: true)
    }
    // ---------- NTT Communications ----------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
