//
//  ThemeFactory.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-18.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

class ThemeFactory {
    static let colors = [
        UIColor(hex: "#582841ff")!,
        UIColor(hex: "#EF3D59ff")!,
        UIColor(hex: "#E17A47ff")!,
        UIColor(hex: "#F18C8Eff")!,
        UIColor(hex: "#DDA5B6ff")!,
        UIColor(hex: "#EFC958ff")!,
        UIColor(hex: "#4AB19Dff")!,
        UIColor(hex: "#568EA6ff")!,
        UIColor(hex: "#325D79ff")!,
        UIColor(hex: "#344E5Cff")!
    ]
    
    static func getRandomTheme() -> EmojiMemoryGame.Theme {
        let themes = [
            EmojiMemoryGame.Theme(name: "Halloween",
                  numberOfPairedCards: 5,
                  emojis: ["👻", "🎃", "🕷", "💀", "🧛‍♂️"],
                  color: colors[0]),
            EmojiMemoryGame.Theme(name: "Sports",
                  numberOfPairedCards: 4,
                  emojis: ["🏈", "🏓", "🏸", "🏂"],
                  color: colors[1]),
            EmojiMemoryGame.Theme(name: "Animals",
                  numberOfPairedCards: 5,
                  emojis: ["🐶", "🐹", "🐯", "🐵", "🐸", "🦆", "🐳"],
                  color: colors[2]),
            EmojiMemoryGame.Theme(name: "Flags",
                  numberOfPairedCards: 8,
                  emojis: ["🏴‍☠️", "🇦🇺", "🇧🇧", "🇪🇺", "🇬🇭", "🇮🇱", "🇾🇪", "🇰🇬", "🇱🇷", "🇯🇲", "🇪🇨", "🇨🇦", "🇸🇪"],
                  color: colors[3]),
            EmojiMemoryGame.Theme(name: "Faces",
                  numberOfPairedCards: 5,
                  emojis: ["🥰", "😎", "😅", "😇", "😭"],
                  color: colors[4]),
            EmojiMemoryGame.Theme(name: "Vehicles",
                  numberOfPairedCards: 6,
                  emojis: ["🚗", "🚎", "🚲", "🚃", "🛩", "🛸"],
                  color: colors[5]),
        ]
        return themes[Int.random(in: 0..<themes.count)]
    }
}
