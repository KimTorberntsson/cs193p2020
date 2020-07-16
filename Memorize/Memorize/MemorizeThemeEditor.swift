//
//  MemorizeThemeEditor.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-07-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    var theme: EmojiMemoryGame.Theme
    @Binding var isShowing: Bool
    @State var themeName: String = ""
    @State var emojiToAdd: String = ""
    
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
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { _ in })
                }
                Section(header: Text("Add Emoji").font(Font.system(.subheadline))) {
                    HStack {
                        TextField("Emoji", text: $emojiToAdd, onEditingChanged:  { _ in})
                        Spacer()
                        Button("Add") { }
                    }
                }
                Section(header:
                    HStack {
                        Text("Emojis").font(Font.system(.subheadline))
                        Spacer()
                        Text("tap emoji to exclude").font(Font.system(.caption))
                }) {
                        Grid(self.theme.emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: 40))
                        }
                        .frame(height: self.emojiGridHeight)
                }
                Section(header: Text("Card Count").font(Font.system(.subheadline))) {
                    HStack {
                        Text("\(theme.numberOfPairedCards) Pairs")
                        Spacer()
                        Stepper(onIncrement: {}, onDecrement: {}, label: { EmptyView() })
                    }
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
