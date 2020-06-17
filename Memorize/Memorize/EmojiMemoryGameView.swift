//
//  ContentView.swift
//  EmojiMemoryGameView
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
    
    var body: some View {
        HStack {
            ForEach (viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(self.viewModel.cards.count == 10 ? Font.headline : Font.largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if (self.card.isFaceUp) {
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: self.lineWidth)
                    Text(self.card.Content)
                } else {
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill()
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
            .font(Font.system(size: self.fontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let lineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * self.fontScaleFactor
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
