//
//  CardTypeEnums.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-22.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

enum Shape: CaseIterable {
    case diamond
    case rectangle
    case oval
}

enum Number: CaseIterable {
    case one
    case two
    case three
}

enum Shading: CaseIterable {
    case solid
    case striped
    case open
}

enum Color: CaseIterable {
    case red
    case green
    case purple
}
