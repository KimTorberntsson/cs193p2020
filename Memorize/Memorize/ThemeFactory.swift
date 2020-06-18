//
//  ThemeFactory.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-18.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

class ThemeFactory {
    static func getRandomTheme() -> EmojiMemoryGame.Theme {
        let themes = [
            EmojiMemoryGame.Theme(name: "Halloween",
                  numberOfPairedCards: Int.random(in: 2...5),
                  emojis: ["👻", "🎃", "🕷", "💀", "🧛‍♂️"],
                  color: Color.orange),
            EmojiMemoryGame.Theme(name: "Sports",
                  numberOfPairedCards: 4,
                  emojis: ["🏈", "🏓", "🏸", "🏂"],
                  color: Color.blue),
            EmojiMemoryGame.Theme(name: "Animals",
                  numberOfPairedCards: 5,
                  emojis: ["🐶", "🐹", "🐯", "🐵", "🐸"],
                  color: Color.green),
            EmojiMemoryGame.Theme(name: "Flags",
                  numberOfPairedCards: Int.random(in: 3...10),
                  emojis: ["🏴‍☠️", "🇦🇺", "🇧🇧", "🇪🇺", "🇬🇭", "🇮🇱", "🇾🇪", "🇰🇬", "🇱🇷", "🇯🇲"],
                  color: Color.black),
            EmojiMemoryGame.Theme(name: "Faces",
                  numberOfPairedCards: Int.random(in: 2...6),
                  emojis: ["🥰", "😎", "😅", "😇", "😡", "😭"],
                  color: Color.yellow),
            EmojiMemoryGame.Theme(name: "Vehicles",
                  numberOfPairedCards: Int.random(in: 2...6),
                  emojis: ["🚗", "🚎", "🚲", "🚃", "🛩", "🛸"],
                  color: Color.gray),
        ]
        return themes[Int.random(in: 0..<themes.count)]
    }
}
