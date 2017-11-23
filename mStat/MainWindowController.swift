//
//  MainWindowController.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        // Customization
        window?.styleMask.insert(.fullSizeContentView)
        window?.titlebarAppearsTransparent = true
        window?.isMovableByWindowBackground = true
        window?.titleVisibility = .hidden
    }
    
    var preferenceWindowController: PreferenceWindowController?

    @IBAction func showAppPreferences(_ sender: Any?) {
        let storyboardID = "PreferenceWindowController"
        if preferenceWindowController == nil { preferenceWindowController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: storyboardID)) as? PreferenceWindowController }
        preferenceWindowController?.showWindow(nil)
    }
}
