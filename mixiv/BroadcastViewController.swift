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
    @IBOutlet weak var idLabel: UILabel!

    private var _peer: SKWPeer?
    private var _msLocal: SKWMediaStream?
    private var _msRemote: SKWMediaStream?
    private var _mediaConnection: SKWMediaConnection?
    private var _id: String? = nil
    private var _bEstablished: Bool = false
    private var _listPeerIds: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        vwVideo.tag = ViewTag.TAG_LOCAL_VIDEO.hashValue

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
                self.idLabel.text = "配信ID：\(self._id!)"
            })
        })

        SKWNavigator.initialize(_peer);
        let constraints: SKWMediaConstraints = SKWMediaConstraints.init();
        _msLocal = SKWNavigator.getUserMedia(constraints) as SKWMediaStream

        let localVideoView: SKWVideo = vwVideo.viewWithTag(ViewTag.TAG_LOCAL_VIDEO.hashValue) as! SKWVideo
        localVideoView.addSrc(_msLocal, track: 0)

        _peer?.on(SKWPeerEventEnum.PEER_EVENT_CALL, callback: { (obj: NSObject!) -> Void in
            self._mediaConnection = obj as? SKWMediaConnection
            self._mediaConnection?.answer(self._msLocal);
            self._bEstablished = true
        })
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("(`0言0́*)<ヴェアアアアアアアア")
//        _peer?.destroy()
    }

    func setMediaCallbacks(media: SKWMediaConnection) {
        media.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM, callback: { (obj: NSObject!) -> Void in
            self._msRemote = obj as? SKWMediaStream

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let remoteVideoView: SKWVideo = self.view.viewWithTag(ViewTag.TAG_REMOTE_VIDEO.hashValue) as! SKWVideo
                remoteVideoView.hidden = false
                remoteVideoView.addSrc(self._msRemote, track: 0)
            })
        })

        media.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE, callback: { (obj: NSObject!) -> Void in
            self._msRemote = obj as? SKWMediaStream

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let remoteVideoView: SKWVideo = self.view.viewWithTag(ViewTag.TAG_REMOTE_VIDEO.hashValue) as! SKWVideo
                remoteVideoView.removeSrc(self._msRemote, track: 0)
                self._msRemote = nil
                self._mediaConnection = nil
                self._bEstablished = false
                remoteVideoView.hidden = true
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BroadcastViewController: UINavigationControllerDelegate, UIAlertViewDelegate {
}
