//
//  FavoriteTableCellView.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/07.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class FavoriteTableCellView: UITableViewCell {
    @IBOutlet weak var illustViewLeft: UIImageView!
    @IBOutlet weak var userIconViewLeft: UIImageView!
    @IBOutlet weak var illustViewRight: UIImageView!
    @IBOutlet weak var userIconViewRight: UIImageView!

    class func instance() -> FavoriteTableCellView {

        return UINib(nibName: "IllustTableCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FavoriteTableCellView
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        illustViewLeft.tag = 100
        userIconViewLeft.tag = 150
        illustViewRight.tag = 200
        userIconViewRight.tag = 250

        illustViewLeft.userInteractionEnabled = true
        let tapGestureIVL = UITapGestureRecognizer(target: self, action: #selector(FavoriteTableCellView.touchEventIVL(_:)))
        illustViewLeft.addGestureRecognizer(tapGestureIVL)

        userIconViewLeft.userInteractionEnabled = true
        let tapGestureUVL = UITapGestureRecognizer(target: self, action: #selector(FavoriteTableCellView.touchEventUVL(_:)))
        userIconViewLeft.addGestureRecognizer(tapGestureUVL)

        illustViewRight.userInteractionEnabled = true
        let tapGestureIVR = UITapGestureRecognizer(target: self, action: #selector(FavoriteTableCellView.touchEventIVR(_:)))
        illustViewRight.addGestureRecognizer(tapGestureIVR)

        userIconViewRight.userInteractionEnabled = true
        let tapGestureUVR = UITapGestureRecognizer(target: self, action: #selector(FavoriteTableCellView.touchEventUVR(_:)))
        userIconViewRight.addGestureRecognizer(tapGestureUVR)
    }

    @IBAction func touchEventIVL(sender: AnyObject) {
        UIApplication.sharedApplication().sendAction(#selector(HomeViewController.touchAction(_:)), to: nil, from: illustViewLeft, forEvent: nil)
    }

    @IBAction func touchEventUVL(sender: AnyObject) {
        UIApplication.sharedApplication().sendAction(#selector(HomeViewController.touchAction(_:)), to: nil, from: userIconViewLeft, forEvent: nil)
    }

    @IBAction func touchEventIVR(sender: AnyObject) {
        UIApplication.sharedApplication().sendAction(#selector(HomeViewController.touchAction(_:)), to: nil, from: illustViewRight, forEvent: nil)
    }

    @IBAction func touchEventUVR(sender: AnyObject) {
        UIApplication.sharedApplication().sendAction(#selector(HomeViewController.touchAction(_:)), to: nil, from: userIconViewRight, forEvent: nil)
    }

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
