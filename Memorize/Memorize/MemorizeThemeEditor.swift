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
                themeNameSection
                addEmojiSection
                emojisSection
                if theme.deletedEmojis.count > 0 {
                    deletedEmojiSection
                }
                cardCountSection
                colorSection
            }
        }
    }
    
    private var themeNameSection: some View {
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
    
    private var addEmojiSection: some View {
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
    
    private var emojisSection: some View {
        Section(header:
            HStack {
                Text("Emojis").font(Font.system(.subheadline))
                Spacer()
                Text("tap emoji to exclude").font(Font.system(.caption))
            }
        ) {
            Grid(self.theme.emojis, id: \.self) { emoji in
                Text(emoji)
                    .font(Font.system(size: self.emojiFontSize))
                    .onTapGesture {
                        self.store.remove(emoji, for: self.theme)
                }
            }
            .frame(height: self.emojiGridHeight)
        }
    }
    
    private var deletedEmojiSection: some View {
        Section(header:
            HStack {
                Text("Deleted Emojis").font(Font.system(.subheadline))
                Spacer()
                Text("tap emoji to include").font(Font.system(.caption))
            }
        ) {
            Grid(self.theme.deletedEmojis, id: \.self) { emoji in
                Text(emoji)
                    .font(Font.system(size: self.emojiFontSize))
                    .onTapGesture {
                        self.store.addRemoved(emoji, for: self.theme)
                }
            }
            .frame(height: self.deletedEmojiGridHeight)
        }
    }
    
    private var cardCountSection: some View {
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
    
    private var colorSection: some View {
        Section(header: Text("Color").font(Font.system(.subheadline))) {
            Grid(ThemeFactory.colors, id: \.self) { color in
                self.colorPicker(for: color)
            }
            .frame(height: self.colorGridHeight)
        }
    }
    
    @ViewBuilder
    private func colorPicker(for color: UIColor) -> some View {
        if Color(color) == self.theme.color {
            ZStack {
                Circle()
                    .foregroundColor(.black)
                    .padding(self.colorPadding - 4)
                Circle()
                    .foregroundColor(Color(color))
                    .padding(self.colorPadding)
                    .onTapGesture {
                        self.store.set(color: color, for: self.theme)
                }
            }
        } else {
            Circle()
                .foregroundColor(Color(color))
                .padding(self.colorPadding)
                .onTapGesture {
                    self.store.set(color: color, for: self.theme)
            }
        }
    }
    
    // MARK: -- Drawing Constants
    
    var emojiGridHeight: CGFloat {
        CGFloat((theme.emojis.count - 1) / 6) * 70 + 70
    }
    
    var deletedEmojiGridHeight: CGFloat {
        CGFloat((theme.deletedEmojis.count - 1) / 6) * 70 + 70
    }
    
    var colorGridHeight: CGFloat {
        CGFloat((ThemeFactory.colors.count - 1) / 6) * 70 + 70
    }
    
    let colorPadding: CGFloat = 10
    let colorSize: CGFloat = 50
    let emojiFontSize: CGFloat = 40
}
