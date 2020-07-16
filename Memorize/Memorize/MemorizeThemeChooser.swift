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
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination:
                        EmojiMemoryGameView(memoryGame: EmojiMemoryGame(theme: theme))
                            .navigationBarTitle(Text("\(theme.name)"), displayMode: .inline)) {
                                MemorizeThemeRow(theme: theme, editMode: self.$editMode)
                                    .environmentObject(self.store)
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
            .environment(\.editMode, $editMode)
        }
    }
}

struct MemorizeThemeRow: View {
    @EnvironmentObject var store: MemorizeThemeStore
    var theme: EmojiMemoryGame.Theme
    
    @Binding var editMode: EditMode
    @State private var themeEditorOpen = false
    
    var body: some View {
        HStack {
            if editMode.isEditing {
                Image(systemName: "slider.horizontal.3")
                    .imageScale(.large)
                    .padding(.trailing)
                    .foregroundColor(theme.color)
                    .onTapGesture {
                        if self.editMode.isEditing {
                            self.themeEditorOpen = true
                        }
                    }
            }
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
            .sheet(isPresented: self.$themeEditorOpen) {
                MemorizeThemeEditor(theme: self.theme, isShowing: self.$themeEditorOpen)
                    .environmentObject(self.store)
            }
        }
    }
}

struct MemorizeThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        let store = MemorizeThemeStore()
        return MemorizeThemeChooser(store: store)
    }
}
