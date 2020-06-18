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
    @Published private var model: MemoryGame<String>
    var theme : Theme
    
    init() {
        let theme = ThemeFactory.getRandomTheme()
        self.theme = theme
        
        model = MemoryGame<String>(numberOfPairedCards: theme.numberOfPairedCards) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the model

    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    struct Theme {
        var name: String
        var numberOfPairedCards: Int
        var emojis: [String]
        var color: Color
    }
}
