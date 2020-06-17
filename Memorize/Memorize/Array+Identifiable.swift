//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-17.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int {
        for index in 0..<self.count {
            if (self[index].id == matching.id) {
                return index;
            }
        }
        return 0 // TODO: - Bogus!
    }
}
