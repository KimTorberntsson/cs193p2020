//
//  ThemeStore.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-14.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI
import Combine

class MemorizeThemeStore: ObservableObject {
    let name: String
    let minNumberOfPairedCards = 2
    
    @Published var themes = [EmojiMemoryGame.Theme]()
    private var autosave: AnyCancellable?
    
    init(named name: String = "Memorize") {
        self.name = name
        
        let defaultsKey = "MemorizeThemeStore.\(name)"
        let plist = UserDefaults.standard.object(forKey: defaultsKey)
        if let json = plist as? Data {
            if let newTheme = try? JSONDecoder().decode([EmojiMemoryGame.Theme].self, from: json) {
                themes = newTheme
            }
        }
        
        autosave = $themes.sink { themes in
            let json =  try? JSONEncoder().encode(themes)
            print("json: \(json?.utf8 ?? "nil")")
            UserDefaults.standard.set(json, forKey: defaultsKey)
        }
    }
    
    func getName(for theme: EmojiMemoryGame.Theme) -> String {
        themes[index(of: theme)!].name
    }
    
    func set(name: String, for theme: EmojiMemoryGame.Theme) {
        themes[index(of: theme)!].name = name
    }
    
    func getEmojis(for theme: EmojiMemoryGame.Theme) -> [String] {
        themes[index(of: theme)!].emojis
    }
    
    func add(_ emojis: String, for theme: EmojiMemoryGame.Theme) {
        guard !emojis.isEmpty else {
            return
        }
        
        themes[index(of: theme)!].emojis = (getEmojis(for: theme).joined() + emojis).uniqued().map { String($0) }
    }
    
    func remove(_ emoji: String, for theme: EmojiMemoryGame.Theme) {
        // Don't remove emoji if we are at the minimum number of emojis.
        if theme.emojis.count <= minNumberOfPairedCards {
            return
        }
        
        let filteredEmojis = theme.emojis.filter {
            !emoji.contains($0)
        }
        if filteredEmojis.count != theme.emojis.count {
            // The emoji was filtered away, so add it to the deleted emojis.
            themes[index(of: theme)!].deletedEmojis.append(emoji)
        }
        themes[index(of: theme)!].emojis = filteredEmojis
        
        // Make sure that we don't end up with more pairs than we have emojis.
        themes[index(of: theme)!].numberOfPairedCards = min(theme.numberOfPairedCards, getEmojis(for: theme).count)
    }
    
    func addRemoved(_ emoji: String, for theme: EmojiMemoryGame.Theme) {
        add(emoji, for: theme)
        themes[index(of: theme)!].deletedEmojis = theme.deletedEmojis.filter {
            !emoji.contains($0)
        }
    }
    
    func getNumberOfPairedCards(for theme: EmojiMemoryGame.Theme) -> Int {
        themes[index(of: theme)!].numberOfPairedCards
    }
    
    func set(numberOfPairedCards: Int, for theme: EmojiMemoryGame.Theme) {
        themes[index(of: theme)!].numberOfPairedCards = numberOfPairedCards
    }
    
    func set(color: UIColor, for theme: EmojiMemoryGame.Theme) {
        themes[index(of:theme)!].rgb = color.rgb
    }
    
    private func index(of theme: EmojiMemoryGame.Theme) -> Int? {
        themes.firstIndex(matching: theme)
    }
}
