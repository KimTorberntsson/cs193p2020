//
//  ShapeSetGame.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

typealias ShapeSetGame = SetGame<SetGameWithShapes.Shape, SetGameWithShapes.Number, SetGameWithShapes.Shading, SetGameWithShapes.Color>
typealias SetGameCard = SetGame<SetGameWithShapes.Shape, SetGameWithShapes.Number, SetGameWithShapes.Shading, SetGameWithShapes.Color>
    .Card<SetGameWithShapes.Shape, SetGameWithShapes.Number, SetGameWithShapes.Shading, SetGameWithShapes.Color>

class SetGameWithShapes: ObservableObject {
    
    @Published private var game: ShapeSetGame
    
    init() {
        game = ShapeSetGame()
        game.choose(card: game.activeCards[2])
    }
    
    // MARK: - Access to model
    var activeCards: [SetGameCard] {
        game.activeCards
    }
    
    // MARK: - Intents
    func choose(card: SetGameCard) {
        game.choose(card: card)
    }
    
    // MARK: - Enums
    
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
}
