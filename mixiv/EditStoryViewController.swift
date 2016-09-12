//
//  EditStoryViewController.swift
//  mixiv
//
//  Created by 板谷晃良 on 2016/09/10.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit
import ASAutoResizingTextView

class EditStoryViewController: UIViewController {
    @IBOutlet weak var sendBar: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendTextView: ASAutoResizingTextView!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBarHeightConstraint: NSLayoutConstraint!

    var diffConstant: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "edit_bk")!)
        initSendBar()
    }

    private func initSendBar() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditStoryViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditStoryViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil);

        diffConstant = sendBarHeightConstraint.constant - sendTextViewHeightConstraint.constant
        sendTextView.autoresizeTextViewDelegate = self
        sendButton.addTarget(self, action: #selector(EditStoryViewController.sendMessage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    // MARK: Keyboard Delegate
    func keyboardWillHide(notification: NSNotification) {
        guard let _ = notification.userInfo else {
            return
        }

        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomSpacingConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    func keyboardWillShow(notification: NSNotification) {

        guard let userInfo = notification.userInfo else {
            return
        }

        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: {
            () -> Void in

            self.bottomSpacingConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        })
    }

    // MARK: Actions
    func sendMessage(sender: AnyObject) {

        sendTextView.resignFirstResponder()
        sendTextView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditStoryViewController: ASAutoResizingTextViewDelegate {

    func didAutolayoutContraintChanged(constantHeight: CGFloat) {
        sendBarHeightConstraint.constant = constantHeight + 20
    }
}