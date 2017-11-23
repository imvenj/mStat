//
//  NSAlertExtension.swift
//  mStat
//
//  Created by venj on 2017/11/23.
//  Copyright © 2017年 venj. All rights reserved.
//

import Cocoa

extension NSAlert {
    /**
     Convenient class method that shows a sheet (or modal) alert.
     
     - parameter withMessageText: Title of the alert
     - parameter informativeText: Detailed text of the alert
     - parameter firstButtonTitle: The default button title
     - parameter secondButtonTitle: The title of the button beside the default button
     - parameter thirdButtonTitle: The Farthest button title
     - parameter showInWindow: Associated alert to a window, can be `nil`
     - parameter asSheet: Whether show the alert as a sheet or modal, default is `true`
     - parameter completionHandler: Handle user reaction to the alert
     */
    class func alert(withMessageText title: String, informativeText: String, firstButtonTitle: String? = nil, secondButtonTitle: String? = nil, thirdButtonTitle: String? = nil, showInWindow window: NSWindow? = nil, asSheet: Bool = true, completionHandler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = informativeText
            if let firstButtonTitle = firstButtonTitle { alert.addButton(withTitle: firstButtonTitle) }
            if let secondButtonTitle = secondButtonTitle { alert.addButton(withTitle: secondButtonTitle) }
            if let thirdButtonTitle = thirdButtonTitle { alert.addButton(withTitle: thirdButtonTitle) }
            if window != nil && asSheet {
                alert.beginSheetModal(for: window!, completionHandler: completionHandler)
            }
            else {
                let response = alert.runModal()
                completionHandler?(response)
            }
        }
    }
}
