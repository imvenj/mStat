//
//  Device.swift
//  mStat Widget
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//


import Foundation
import SystemConfiguration

typealias DefaultRouteType = (device: String?, gateway: String?, serviceIDv4: String?, device6: String?, gateway6: String?, serviceIDv6: String?)

class Device {
    static let current = Device()
    private init() {}

    /**
     Get current default gateway both v4 and v6.

     - returns: Returns a tuple. First member is gateway's network interface name for IPv4, second member is gateway's IPv4 address; Third member is gateway's network interface name for IPv6, fourth member is gateway's IPv6 address.
     */
    func defaultRoute() -> DefaultRouteType {
        let ds = SCDynamicStoreCreate(kCFAllocatorDefault, "me.venj.mStat.mStat-Widget" as CFString, nil, nil)
        let key = ("State:/Network/Global/IPv4")  as CFString
        let dr = SCDynamicStoreCopyValue(ds, key) as? [String: String]
        let key6 = ("State:/Network/Global/IPv6")  as CFString
        let dr6 = SCDynamicStoreCopyValue(ds, key6) as? [String: String]
        return (dr?["PrimaryInterface"], dr?["Router"], dr?["PrimaryService"]?.lowercased(), dr6?["PrimaryInterface"], dr6?["Router"], dr6?["PrimaryService"]?.lowercased())
    }
}
