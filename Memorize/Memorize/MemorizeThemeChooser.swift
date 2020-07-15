//
//  MemorizeThemeChooser.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-14.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct MemorizeThemeChooser: View {
    @ObservedObject var store: MemorizeThemeStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination:
                        EmojiMemoryGameView(memoryGame: EmojiMemoryGame(theme: theme))
                            .navigationBarTitle(Text("\(theme.name)"), displayMode: .inline)) {
                                self.body(for: theme)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.store.themes[$0] }.forEach { theme in
                        self.store.themes.removeAll(where: { $0.id == theme.id })
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(
                leading: Button(action: {
                    self.store.themes.append(ThemeFactory.getRandomTheme())
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
        }
    }
    
    func body(for theme: EmojiMemoryGame.Theme) -> some View {
        VStack(alignment: .leading) {
            Text("\(theme.name)").foregroundColor(theme.color)
                .font(Font.system(.title))
            if (theme.emojis.count == theme.numberOfPairedCards) {
                Text("All of \(theme.emojis.joined())")
            } else {
                Text("\(theme.numberOfPairedCards) pairs from \(theme.emojis.joined())")
            }
        }
        .lineLimit(1)
    }
}

struct MemorizeThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        let store = MemorizeThemeStore()
        store.themes.append(ThemeFactory.getRandomTheme())
        store.themes.append(ThemeFactory.getRandomTheme())
        store.themes.append(ThemeFactory.getRandomTheme())
        return MemorizeThemeChooser(store: store)
    }
}
