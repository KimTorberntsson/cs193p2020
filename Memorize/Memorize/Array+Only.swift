//
//  Array+Only.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-17.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
