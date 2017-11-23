//
//  ViewController.swift
//  mStat
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func showPreferences(_ sender: Any) {
        if let windowController = view.window?.windowController as? MainWindowController {
            windowController.showAppPreferences(sender)
        }
    }
    
}

