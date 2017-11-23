//
//  Configuration.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

enum RefreshRate: Double {
    typealias RawValue = Double
    
    case fast = 0.5
    case normal = 1.0
    case slow = 2.0
    case verySlow = 5.0
}

class Configuration {
    static let shared = Configuration()
    private init() {}
    
    private static let suiteName = "32Y52676KN.me.venj.mStat-Mac"
    
    private let refreshRateKey = "RefreshRate"
    private let normalColorKey = "NormalColorKey"
    private let warningColorKey = "WarningColorKey"
    private let criticalColorKey = "CriticalColorKey"
    
    let defaults = UserDefaults(suiteName: Configuration.suiteName)!
    
    private func read<T>(key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    private func write(_ object: Any?, forKey key: String) {
        if let object = object {
            defaults.set(object, forKey: key)
        }
        else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    //MARK: - Properties
    var refreshRate: Double {
        get {
            return read(key: refreshRateKey) ?? 1.0
        }
        set {
            write(newValue, forKey: refreshRateKey)
        }
    }
    
    var normalColor: NSColor {
        get {
            guard let colorComponents: [Double] = read(key: normalColorKey) else {
                return Theme.normalColor
            }
            return NSColor(components: colorComponents)
        }
        set {
            let color = newValue
            write(color.components, forKey: normalColorKey)
        }
    }
    
    var warningColor: NSColor {
        get {
            guard let colorComponents: [Double] = read(key: warningColorKey) else {
                return Theme.warningColor
            }
            return NSColor(components: colorComponents)
        }
        set {
            let color = newValue
            write(color.components, forKey: warningColorKey)
        }
    }
    
    var criticalColor: NSColor {
        get {
            guard let colorComponents: [Double] = read(key: criticalColorKey) else {
                return Theme.criticalColor
            }
            return NSColor(components: colorComponents)
        }
        set {
            let color = newValue
            write(color.components, forKey: criticalColorKey)
        }
    }
}
