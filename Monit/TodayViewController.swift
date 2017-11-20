//
//  TodayViewController.swift
//  Monit
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet weak var cpuProgressBar: ProgressBar!
    @IBOutlet weak var cpuPercentLabel: NSTextField!
    @IBOutlet weak var memoryProgressBar: ProgressBar!
    @IBOutlet weak var memoryPercentLabel: NSTextField!
    @IBOutlet weak var hddProgressBar: ProgressBar!
    @IBOutlet weak var hddPercentLabel: NSTextField!
    @IBOutlet weak var downloadLabel: NSTextField!
    @IBOutlet weak var uploadLabel: NSTextField!
    
    var timer: Timer?
    var sys = System()
    var previousDataUsage: data_usage? = nil
    
    let updateInterval: UInt = 1
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        print("View will disappear")
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        print("View did disappear")
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
        sys = System()
        updateUI(nil)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Double(updateInterval), target: self, selector: #selector(updateUI(_:)), userInfo: nil, repeats: true)
        }
        completionHandler(.newData)
    }
    
    @objc func updateUI(_ aTimer: Timer?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            // CPU
            let cpu = self.sys.usageCPU()
            let cpuUsed = 100.0 - cpu.idle
            self.cpuProgressBar.current = cpuUsed
            self.cpuPercentLabel.stringValue = "\(Int(cpuUsed))%"
            switch cpuUsed {
            case 0..<40:
                self.cpuProgressBar.tintColor = Theme.normalColor
            case 40..<70:
                self.cpuProgressBar.tintColor = Theme.warningColor
            case 70...:
                self.cpuProgressBar.tintColor = Theme.criticalColor
            default:
                self.cpuProgressBar.tintColor = Theme.normalColor
            }
            
            // Memory
            let mem = System.memoryUsage()
            let memUsed = (mem.wired + mem.active + mem.compressed) * 100 / System.physicalMemory(.gigabyte)
            self.memoryProgressBar.current = memUsed
            self.memoryPercentLabel.stringValue = "\(Int(memUsed))%"
            
            switch memUsed {
            case 0..<50:
                self.memoryProgressBar.tintColor = Theme.normalColor
            case 50..<80:
                self.memoryProgressBar.tintColor = Theme.warningColor
            case 80...:
                self.memoryProgressBar.tintColor = Theme.criticalColor
            default:
                self.memoryProgressBar.tintColor = Theme.normalColor
            }
            // Disk
            
        }
        
        // Networking
        let route = Device.current.defaultRoute()
        if let interface = route.device6 != nil ? route.device6! : route.device {
            let dataUsage = get_data_usage(interface)
            if let previousDataUsage = previousDataUsage {
                let downloadSpeed = (dataUsage.download - previousDataUsage.download) / UInt64(updateInterval)
                let uploadSpeed = (dataUsage.upload - previousDataUsage.upload) / UInt64(updateInterval)
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    // Update UI
                    self.downloadLabel.stringValue = self.formattedSpeedString(with: downloadSpeed)
                    self.uploadLabel.stringValue = self.formattedSpeedString(with: uploadSpeed)
                }
                self.previousDataUsage = dataUsage
            }
            else {
                // First update
                previousDataUsage = dataUsage
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    // Update UI
                    self.downloadLabel.stringValue = self.formattedSpeedString(with: 0)
                    self.uploadLabel.stringValue = self.formattedSpeedString(with: 0)
                }
            }
        }
        else {
            // Network interface inactive.
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                // Update UI
                self.downloadLabel.stringValue = "--"
                self.uploadLabel.stringValue = "--"
            }
        }
    }
    
    func formattedSpeedString(with usage: UInt64) -> String {
        switch usage {
        case 0 ..< 900:
            return "\(usage) B/s"
        case 900 ..< (900 * 1024):
            return String(format: "%.1f KB/s", Double(usage) / 1024.0)
        case (900 * 1024) ..< (900 * 1024 * 1024):
            return String(format: "%.1f MB/s", Double(usage) / (1024.0 * 1024.0))
        default:
            return String(format: "%.1f GB/s", Double(usage) / (1024.0 * 1024.0 * 1024.0))
        }
    }

}
