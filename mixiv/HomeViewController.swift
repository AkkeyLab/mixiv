//
//  HomeViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/04.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var adScrollView: UIScrollView!
    private var scrollHeight: CGFloat!
    private var scrollWidth: CGFloat!
    private let scrollItem: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollWidth = adScrollView.bounds.width
        scrollHeight = adScrollView.bounds.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height

        var num: Int = 0
        for _ in 1...scrollItem {
            let view: UIView = UINib(nibName: "Advertisement", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! UIView
            view.frame = CGRectMake(0, -(navBarHeight! + statusBarHeight), scrollWidth, scrollHeight)
            view.tag = num
            self.adScrollView.addSubview(view)

            num += 1
        }
    }

    func setupScrollItem() {
        var subviews: Array = adScrollView.subviews
        
        var num: Int = 0
        for _ in subviews {
            if 
        }
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