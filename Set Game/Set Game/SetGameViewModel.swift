//
//  ShapeSetGame.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias ShapeSetGame = SetGame<Shape, Number, Shading, Color>
    typealias SetGameCard = SetCard<Shape, Number, Shading, Color>
    
    @Published private var game: ShapeSetGame
    
    init() {
        game = ShapeSetGame()
    }
    
    func getRandomOffset(for size: CGSize) -> CGSize {
        let length = Double(sqrt(size.height*size.height + size.width*size.width))
        let angle = Angle.degrees(Double.random(in: 0..<360))
        return CGSize(width: length*cos(angle.radians), height: length*sin(angle.radians))
    }
    
    // MARK: - Access to model
    var activeCards: [SetGameCard] {
        game.activeCards
    }
    
    // MARK: - Intents
    func choose(card: SetGameCard) {
        game.choose(card: card)
    }
    
    func cheat() {
        game.cheat()
    }
    
    func drawInitialCards() {
        game.drawInitialCards()
    }
    
    func drawAdditionalCards() {
        game.drawAdditionalCards()
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
