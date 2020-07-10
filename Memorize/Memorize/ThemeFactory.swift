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
                  numberOfPairedCards: 5,
                  emojis: ["👻", "🎃", "🕷", "💀", "🧛‍♂️"],
                  color: UIColor.orange),
            EmojiMemoryGame.Theme(name: "Sports",
                  numberOfPairedCards: 4,
                  emojis: ["🏈", "🏓", "🏸", "🏂"],
                  color: UIColor.blue),
            EmojiMemoryGame.Theme(name: "Animals",
                  numberOfPairedCards: 5,
                  emojis: ["🐶", "🐹", "🐯", "🐵", "🐸"],
                  color: UIColor.green),
            EmojiMemoryGame.Theme(name: "Flags",
                  numberOfPairedCards: 10,
                  emojis: ["🏴‍☠️", "🇦🇺", "🇧🇧", "🇪🇺", "🇬🇭", "🇮🇱", "🇾🇪", "🇰🇬", "🇱🇷", "🇯🇲"],
                  color: UIColor.black),
            EmojiMemoryGame.Theme(name: "Faces",
                  numberOfPairedCards: 5,
                  emojis: ["🥰", "😎", "😅", "😇", "😭"],
                  color: UIColor.yellow),
            EmojiMemoryGame.Theme(name: "Vehicles",
                  numberOfPairedCards: 6,
                  emojis: ["🚗", "🚎", "🚲", "🚃", "🛩", "🛸"],
                  color: UIColor.gray),
        ]
        return themes[Int.random(in: 0..<themes.count)]
    }
}
