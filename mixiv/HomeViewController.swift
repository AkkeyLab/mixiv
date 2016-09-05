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
    @IBOutlet weak var adStatusView: UIView!
    private var scrollHeight: CGFloat!
    private var scrollWidth: CGFloat!
    private let scrollItem: Int = 5
    private var guttlerPageControl: GuttlerPageControl!
    private var pageIndex: Int = 0
    private var goPage: Bool = true

    private let adText: [String] = ["映画館で絶賛放映中!!「君の名は。」公開記念イベント中!",
        "ちっちゃくてカワイイSDキャラクター特集!",
        "味のある鉛筆作品が大集合!!",
        "美しい夜景イラスト特集!",
        "まだまだ大人気!ラブライブイラストが大集合!!"]

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollWidth = self.view.frame.size.width
        scrollHeight = scrollWidth * (9 / 16)

        adScrollView.showsHorizontalScrollIndicator = false
        adScrollView.showsVerticalScrollIndicator = false
        adScrollView.pagingEnabled = true
        adScrollView.scrollEnabled = true
        adScrollView.bounces = true
        adScrollView.scrollsToTop = false
        adScrollView.delegate = self
        adScrollView.contentSize = CGSizeMake(CGFloat(scrollItem) * scrollWidth, 0)

        var num: Int = 0
        for _ in 1...scrollItem {
            let view = AdvertisementView.instance()
            view.setImage(UIImage(named: "top_ad_\(num)")!)
            view.setText(adText[num])
            view.frame = CGRectMake(scrollWidth * CGFloat(num), 0, adScrollView.bounds.size.width, adScrollView.bounds.size.height)
            view.tag = num
            self.adScrollView.addSubview(view)

            num += 1
        }

        // Just init with position and numOfpage
        guttlerPageControl = GuttlerPageControl(center: CGPointMake(scrollWidth / 2, adStatusView.frame.size.height / 2), pages: scrollItem)
        // Must bind pageControl with the scrollView
        guttlerPageControl.bindScrollView = adScrollView
        adStatusView.addSubview(guttlerPageControl)

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