//
//  GeneralPreferenceViewController.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

class GeneralPreferenceViewController: NSViewController {

    @IBOutlet weak var normalColorWell: NSColorWell!
    @IBOutlet weak var warningColorWell: NSColorWell!
    @IBOutlet weak var criticalColorWell: NSColorWell!
    @IBOutlet weak var refreshRatePopupButton: NSPopUpButton!
    
    let config = Configuration.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        title = NSLocalizedString("General", comment: "General")
        // Load current value from user defaults
        normalColorWell.color = config.normalColor
        warningColorWell.color = config.warningColor
        criticalColorWell.color = config.criticalColor
    }
    
    @IBAction func colorChanged(_ sender: NSColorWell?) {
        guard let colorWell = sender else { return }
        if colorWell.tag == 0 {
            config.normalColor = colorWell.color
        }
        else if colorWell.tag == 1 {
            config.warningColor = colorWell.color
        }
        else if colorWell.tag == 2 {
            config.criticalColor = colorWell.color
        }
        else {
            // Won't hit
        }
    }
    
    @IBAction func refreshRateChanged(_ sender: NSPopUpButton?) {
        if let tag = sender?.selectedTag() {
            if tag == 0 {
                config.refreshRate = RefreshRate.fast.rawValue
            }
            else if tag == 1 {
                config.refreshRate = RefreshRate.normal.rawValue
            }
            else if tag == 2 {
                config.refreshRate = RefreshRate.slow.rawValue
            }
            else if tag == 3 {
                config.refreshRate = RefreshRate.verySlow.rawValue
            }
            else {
                // Won't hit
            }
        }
    }
    
    @IBAction func resetToDefault(_ sender: Any) {
        normalColorWell.color = Theme.normalColor
        warningColorWell.color = Theme.warningColor
        criticalColorWell.color = Theme.criticalColor
        refreshRatePopupButton.select(refreshRatePopupButton.menu?.items[1])
        
        // Save to user defaults
        config.normalColor = Theme.normalColor
        config.warningColor = Theme.warningColor
        config.criticalColor = Theme.criticalColor
        config.refreshRate = RefreshRate.normal.rawValue
    }
    
    func selectMenuItem(by refreshRate: RefreshRate) {
        switch refreshRate {
        case .fast:
            refreshRatePopupButton.select(refreshRatePopupButton.menu?.items[0])
        case .normal:
            refreshRatePopupButton.select(refreshRatePopupButton.menu?.items[1])
        case .slow:
            refreshRatePopupButton.select(refreshRatePopupButton.menu?.items[2])
        case .verySlow:
            refreshRatePopupButton.select(refreshRatePopupButton.menu?.items[3])
        }
    }
    
}
