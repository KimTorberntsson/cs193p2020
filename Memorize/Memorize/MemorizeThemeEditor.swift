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
                Section(header: Text("Emojis").font(Font.system(.headline))) {
                    Text("\(theme.emojis.joined())")
                }
            }
        }
    }
}
