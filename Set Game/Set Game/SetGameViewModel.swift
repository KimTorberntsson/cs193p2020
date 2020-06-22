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
    
    func drawCard() {
        game.drawCard()
    }
    
    // MARK: - Intents
    func choose(card: SetGameCard) {
        game.choose(card: card)
    }
}
