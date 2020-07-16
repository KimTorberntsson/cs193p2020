//
//  String+Manipulation.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

extension String {
    // returns ourself without any duplicate Characters
    // not very efficient, so only for use on small-ish Strings
    func uniqued() -> String {
        var uniqued = ""
        for ch in self {
            if !uniqued.contains(ch) {
                uniqued.append(ch)
            }
        }
        return uniqued
    }
}
