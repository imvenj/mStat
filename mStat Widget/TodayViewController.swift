//
//  TodayViewController.swift
//  mStat Widget
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
    @IBOutlet weak var loadLabel: NSTextField!
    @IBOutlet weak var uptimeLabel: NSTextField!
    @IBOutlet weak var batteryTitleLabal: NSTextField!
    @IBOutlet weak var batteryPercentLabel: NSTextField!
    @IBOutlet weak var batteryProgressBar: ProgressBar!
    @IBOutlet weak var batteryTimeLabel: NSTextField!
    @IBOutlet weak var batteryInfoLabel: NSTextField!
    
    var timer: Timer?
    var sys = System()
    var previousDataUsage: data_usage? = nil
    var currentInterface: String?
    
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
        let route = Device.current.defaultRoute()
        currentInterface = route.device6 != nil ? route.device6! : route.device
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Double(updateInterval), target: self, selector: #selector(updateUI(_:)), userInfo: nil, repeats: true)
        }
        updateUI(nil)
        updateDiskInfomation()
        updateBatteryInformation()
        completionHandler(.newData)
    }
    
    @objc func updateUI(_ aTimer: Timer?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            // CPU
            let cpu = self.sys.usageCPU()
            let cpuUsed = 100.0 - cpu.idle
            self.cpuProgressBar.current = cpuUsed
            self.cpuPercentLabel.stringValue = String(format:"%.0f%%", cpuUsed)
            switch cpuUsed {
            case 0..<50:
                self.cpuProgressBar.tintColor = Theme.normalColor
            case 50..<80:
                self.cpuProgressBar.tintColor = Theme.warningColor
            case 80...:
                self.cpuProgressBar.tintColor = Theme.criticalColor
            default:
                self.cpuProgressBar.tintColor = Theme.normalColor
            }
            
            // Memory
            let mem = System.memoryUsage()
            let memUsed = (mem.wired + mem.active + mem.compressed) * 100 / System.physicalMemory(.gigabyte)
            self.memoryProgressBar.current = memUsed
            self.memoryPercentLabel.stringValue = String(format:"%.0f%%", memUsed)
            
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
        }
        
        // Networking
        if let interface = currentInterface {
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
        
        // Load and uptime
        let loadAverage = System.loadAverage().map { String(format:"%.2f", $0) }.joined(separator: " ")
        let loadAverageString = String(format: NSLocalizedString("Load Average: %@", comment: "Load Average: %@"), loadAverage)
        let uptime = System.uptime()
        let uptimeString = String(format: NSLocalizedString("Uptime: %dd %dh %dm %ds", comment: "Uptime: %dd %dh %dm %ds"), uptime.days, uptime.hrs, uptime.mins, uptime.secs)
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            // Update UI
            self.loadLabel.stringValue = loadAverageString
            self.uptimeLabel.stringValue = uptimeString
        }
    }
    
    func updateDiskInfomation() {
        // Disk
        let fm = FileManager.default
        if let attributes = try? fm.attributesOfFileSystem(forPath: "/"),
            let totalSpace = attributes[FileAttributeKey.systemSize] as? Double,
            let freeSpace = attributes[FileAttributeKey.systemFreeSize] as? Double {
            // Successfully get disk size
            let hddUsed = freeSpace * 100.0 / totalSpace
            hddProgressBar.current = hddUsed
            hddPercentLabel.stringValue = String(format:"%.0f%%", hddUsed)
            switch hddUsed {
            case 0..<50:
                hddProgressBar.tintColor = Theme.normalColor
            case 50..<80:
                hddProgressBar.tintColor = Theme.warningColor
            case 80...:
                hddProgressBar.tintColor = Theme.criticalColor
            default:
                hddProgressBar.tintColor = Theme.normalColor
            }
        }
    }
    
    func updateBatteryInformation() {
        // Battery
        var battery = Battery()
        if battery.open() != kIOReturnSuccess {
            // Mac Desktop?
            batteryInfoLabel.stringValue = NSLocalizedString("Battery not exists.", comment: "Battery not exists.")
            batteryPercentLabel.stringValue = "0%"
            batteryProgressBar.current = 100
            batteryProgressBar.tintColor = NSColor.lightGray
            batteryTimeLabel.stringValue = NSLocalizedString("AC Power", comment: "AC Power")
        }
        else {
            let healthy = battery.maxCapactiy() * 100 / battery.designCapacity()
            let cycles = battery.cycleCount()
            let temperature = battery.temperature()
            let infoString = String(format: NSLocalizedString("%d cycles, %d%% healthy, %.0f℃", comment: "%d cycles, %d%% healthy, %.0f℃"), cycles, healthy, temperature)
            batteryInfoLabel.stringValue = infoString
            
            let charge = battery.charge()
            batteryPercentLabel.stringValue = String(format: "%.1f%%", charge)
            batteryProgressBar.current = charge
            switch charge {
            case 20...:
                self.batteryProgressBar.tintColor = Theme.normalColor
            case 0..<20:
                self.batteryProgressBar.tintColor = Theme.criticalColor
            default:
                self.memoryProgressBar.tintColor = Theme.normalColor
            }
            if battery.isCharging() {
                batteryTimeLabel.stringValue = NSLocalizedString("Charging", comment: "Charging")
            }
            else if battery.isACPowered() {
                batteryTimeLabel.stringValue = NSLocalizedString("AC Power", comment: "AC Power")
            }
            else {
                batteryTimeLabel.stringValue = battery.timeRemainingFormatted()
            }
        }
        
        _ = battery.close()
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
