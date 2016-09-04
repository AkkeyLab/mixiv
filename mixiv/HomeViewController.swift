//
//  HomeViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/04.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit
import GuttlerPageControl

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var adScrollView: UIScrollView!
    private var scrollHeight: CGFloat!
    private var scrollWidth: CGFloat!
    private let scrollItem: Int = 5
    private var guttlerPageControl: GuttlerPageControl!
    private var pageIndex: Int = 0
    private var goPage: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollWidth = self.view.frame.size.width
//        scrollWidth = adScrollView.bounds.size.width
        scrollHeight = scrollWidth * (9 / 16)
//        scrollHeight = adScrollView.bounds.size.height
        NSLog("width:\(scrollWidth)/height:\(scrollHeight)")

        adScrollView.showsHorizontalScrollIndicator = false
        adScrollView.showsVerticalScrollIndicator = false
        adScrollView.pagingEnabled = true
        adScrollView.scrollEnabled = true
        adScrollView.bounces = true
        adScrollView.scrollsToTop = false
        adScrollView.delegate = self
        adScrollView.contentSize = CGSizeMake(CGFloat(scrollItem) * scrollWidth, 0)

        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
        let exceptionHeight = navBarHeight! + statusBarHeight

        var num: Int = 0
        for _ in 1...scrollItem {
            let view: UIView = UINib(nibName: "Advertisement", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! UIView
//            let view: UIImageView = UIImageView(image: UIImage(named: "top_ad"))
            view.frame = CGRectMake(scrollWidth * CGFloat(num), 0, scrollWidth * 1.6, scrollHeight * 1.6)
//            view.frame = CGRectMake(scrollWidth * CGFloat(num), -exceptionHeight, scrollWidth, scrollHeight)
            view.tag = num
            self.adScrollView.addSubview(view)

            num += 1
        }

        // Just init with position and numOfpage
        guttlerPageControl = GuttlerPageControl(center: CGPointMake(scrollWidth / 2, adScrollView.frame.size.height - exceptionHeight + 10), pages: scrollItem)
        // Must bind pageControl with the scrollView
        guttlerPageControl.bindScrollView = adScrollView
        self.view.addSubview(guttlerPageControl)

        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(HomeViewController.update(_:)), userInfo: nil, repeats: true)
    }

    func update(timer: NSTimer) {
        adScrollView.setContentOffset(CGPoint(x: scrollWidth * CGFloat(pageIndex), y: 0), animated: true)
        if pageIndex == (scrollItem - 1) && goPage {
            goPage = false
            pageIndex -= 1
        } else
        if pageIndex == 0 && !goPage {
            goPage = true
            pageIndex += 1
        } else
        if goPage {
            pageIndex += 1
        } else {
            pageIndex -= 1
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guttlerPageControl.scrollWithScrollView(scrollView)
        pageIndex = Int(adScrollView.contentOffset.x / adScrollView.frame.size.width)
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