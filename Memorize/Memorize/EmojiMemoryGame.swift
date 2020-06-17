//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷", "💀", "🧛‍♂️"]
        let numberOfPairedCards = Int.random(in: 2...5)
        return MemoryGame<String>(numberOfPairedCards: numberOfPairedCards) { pairIndex in
            return emojis[pairIndex]
        }
    }

    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
