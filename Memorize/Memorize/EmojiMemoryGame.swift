//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var memoryGame: MemoryGame<String>
    private(set) var theme : Theme
    
    init(theme: Theme) {
        self.theme = theme
        self.memoryGame = EmojiMemoryGame.createGame(from: theme)
    }
    
    static func createGame(from theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairedCards: theme.numberOfPairedCards) { pairIndex in
            return theme.emojis[pairIndex]
        }
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
    
    func reset() {
        self.memoryGame = EmojiMemoryGame.createGame(from: self.theme)
    }
    
    // MARK: - Theme
    
    struct Theme: Codable, Identifiable {
        let id = UUID()
        var name: String
        var numberOfPairedCards: Int
        var emojis: [String]
        var deletedEmojis = [String]()
        var rgb: UIColor.RGB
        
        init(name: String, numberOfPairedCards: Int, emojis: [String], color: UIColor) {
            self.name = name
            self.numberOfPairedCards = numberOfPairedCards
            self.emojis = emojis
            rgb = color.rgb
        }
        
        var color: Color {
            Color(rgb)
        }
    }
}
