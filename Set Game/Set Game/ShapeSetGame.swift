//
//  ShapeSetGame.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

class ShapeSetGame {
    private var game: SetGame<Shape, Number, Shading, Color>
    
    init() {
        game = SetGame<Shape, Number, Shading, Color>()
        game.choose(card: game.activeCards[2])
    }
    
    enum Shape: CaseIterable {
        case diamond
        case squiggle
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
}
