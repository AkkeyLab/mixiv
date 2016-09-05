//
//  AdvertisementView.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/04.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class AdvertisementView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    class func instance() -> AdvertisementView {

        return UINib(nibName: "Advertisement", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! AdvertisementView
    }

    func setImage(image: UIImage) {
        imageView.image = image
    }

    func setText(text: String) {
        textLabel.text = text
    }

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
