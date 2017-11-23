//
//  PreferenceWindowController.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Excluded from Window menu
        window?.isExcludedFromWindowsMenu = true
    }

}
