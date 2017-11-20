//
//  StringExtension.swift
//  mStat Widget
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

import Foundation

extension String {

    /**
     Remove blank characters from bothside of a string.
     */
    func strip() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}
