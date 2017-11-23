//
//  PreferenceTabViewController.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

class PreferenceTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        if let identifier = tabViewItem?.identifier as? String, identifier == "GeneralPreferences" {
            let title = NSLocalizedString("General", comment: "General")
            tabViewItem?.label = title
            view.window?.title = title
        }
    }
    
    override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
        super.transition(from: fromViewController, to: toViewController, options: options, completionHandler: completion)
        if let window = view.window {
            let contentSize = toViewController.view.fittingSize
            let newWindowSize = window.frameRect(forContentRect: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: contentSize)).size
            var frame = window.frame
            frame.origin.y += (frame.size.height - newWindowSize.height)
            frame.size = newWindowSize
            window.animator().setFrame(frame, display: false, animate: true)
        }
    }
    
}
