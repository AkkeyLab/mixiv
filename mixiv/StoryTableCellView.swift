//
//  FavoriteTableCellView.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/07.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class StoryTableCellView: UITableViewCell {

    @IBOutlet weak var userIconViewLeft: UIImageView!
    @IBOutlet weak var userIconViewRight: UIImageView!

    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var textLabelRight: UILabel!
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var textLabelLeft: UILabel!

    class func instance() -> StoryTableCellView {

        return UINib(nibName: "StoryTableCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! StoryTableCellView
    }

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
