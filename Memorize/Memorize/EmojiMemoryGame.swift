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
    
    init() {
        (self.memoryGame, self.theme) = EmojiMemoryGame.createMemoryGameWithTheme()
    }
    
    private static func createMemoryGameWithTheme() -> (MemoryGame<String>, Theme) {
        let theme = ThemeFactory.getRandomTheme()
        let json = try? JSONEncoder().encode(theme)
        print("theme: \(json?.utf8 ?? "nil")")
        
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
    
    struct Theme: Codable {
        var name: String
        var numberOfPairedCards: Int
        var emojis: [String]
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
