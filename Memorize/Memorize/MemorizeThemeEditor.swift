//
//  MemorizeThemeEditor.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct MemorizeThemeEditor: View {
    @EnvironmentObject var store: MemorizeThemeStore
    var theme: EmojiMemoryGame.Theme
    
    @Binding var isShowing: Bool
    
    @State var numberOfPairedCards = 0
    @State var themeName = ""
    @State var emojisToAdd = ""
    
    let minNumberOfPairedCards = 2
    
    var body: some View {
        VStack {
            ZStack {
                Text("\(theme.name)").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: { Text("Done")}).padding()
                }
            }
            Form {
                ThemeNameSection
                AddEmojiSection
                EmojisSection
                CardCountSection
            }
        }
    }
    
    private var ThemeNameSection: some View {
        Section(header: Text("Theme Name").font(Font.system(.subheadline))) {
            TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                if !began && !self.themeName.isEmpty {
                    self.store.set(name: self.themeName, for: self.theme)
                }
            })
            .onAppear {
                self.themeName = self.store.getName(for: self.theme)
            }
        }
    }
    
    private var AddEmojiSection: some View {
        Section(header: Text("Add Emoji").font(Font.system(.subheadline))) {
            HStack {
                TextField("Emoji", text: $emojisToAdd, onEditingChanged:  { began in
                    if !began {
                        self.store.add(self.emojisToAdd, for: self.theme)
                        self.emojisToAdd = ""
                    }
                })
                Spacer()
                Button("Add") {
                    self.store.add(self.emojisToAdd, for: self.theme)
                    self.emojisToAdd = ""
                }
            }
        }
    }
    
    private var EmojisSection: some View {
        Section(header:
            HStack {
                Text("Emojis").font(Font.system(.subheadline))
                Spacer()
                Text("tap emoji to exclude").font(Font.system(.caption))
            }
        ) {
            Grid(self.theme.emojis, id: \.self) { emoji in
                Text(emoji)
                    .font(Font.system(size: 40))
                    .onTapGesture {
                        self.store.remove(emoji, for: self.theme)
                }
            }
            .frame(height: self.emojiGridHeight)
        }
    }
    
    private var CardCountSection: some View {
        Section(header: Text("Card Count").font(Font.system(.subheadline))) {
            HStack {
                Text("\(theme.numberOfPairedCards) Pairs")
                Spacer()
                Stepper("",
                        value: $numberOfPairedCards,
                        in: store.minNumberOfPairedCards...theme.emojis.count,
                        step: 1, onEditingChanged: { _ in
                            self.store.set(numberOfPairedCards: self.numberOfPairedCards, for: self.theme)
                }).onAppear {
                    self.numberOfPairedCards = min(self.store.getNumberOfPairedCards(for: self.theme), self.theme.emojis.count)
                }
            }
        }
    }
    
    // MARK: -- Drawing Constants
    
    var emojiGridHeight: CGFloat {
        CGFloat((theme.emojis.count - 1) / 6) * 70 + 70
    }
    
    let fontSize: CGFloat = 40
}
