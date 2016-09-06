//
//  FavoriteTableCellView.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/07.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class FavoriteTableCellView: UITableViewCell {

    class func instance() -> FavoriteTableCellView {

        return UINib(nibName: "FavoriteTableCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! FavoriteTableCellView
    }

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
