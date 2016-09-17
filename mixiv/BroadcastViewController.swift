//
//  BroadcastViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/17.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class BroadcastViewController: UIViewController {
    @IBOutlet weak var vwVideo: SKWVideo!

    private var _peer: SKWPeer?
    private var _msLocal: SKWMediaStream?
    private var _msRemote: SKWMediaStream?
    private var _mediaConnection: SKWMediaConnection?
    private var _id: String? = nil
    private var _bEstablished: Bool = false
    private var _listPeerIds: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let option: SKWPeerOption = SKWPeerOption.init();
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
//                self.idLabel.text = "your ID: \n\(self._id!)"
            })
        })
        // Do any additional setup after loading the view.
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
