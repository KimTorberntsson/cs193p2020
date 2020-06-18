//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGame: MemoryGame<String>
    var theme : Theme
    
    init() {
        (self.memoryGame, self.theme) = EmojiMemoryGame.createMemoryGameWithTheme()
    }
    
    static func createMemoryGameWithTheme() -> (MemoryGame<String>, Theme) {
        let theme = ThemeFactory.getRandomTheme()
        let game = MemoryGame<String>(numberOfPairedCards: theme.numberOfPairedCards) { pairIndex in
            return theme.emojis[pairIndex]
        }
        
        return (game, theme)
    }
    
    // MARK: - Access to the model

    var cards: Array<MemoryGame<String>.Card> {
        memoryGame.cards
    }
    
    var score: Int {
        memoryGame.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.choose(card: card)
    }
    
    func resetGameWithNewTheme() {
        (self.memoryGame, self.theme) = EmojiMemoryGame.createMemoryGameWithTheme()
    }
    
    // MARK: - Theme
    
    struct Theme {
        var name: String
        var numberOfPairedCards: Int
        var emojis: [String]
        var color: Color
    }
}
