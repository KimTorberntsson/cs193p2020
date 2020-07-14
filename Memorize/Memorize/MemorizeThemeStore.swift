//
//  ThemeStore.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-14.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation
import Combine

class MemorizeThemeStore: ObservableObject {
    let name: String
    
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
}
