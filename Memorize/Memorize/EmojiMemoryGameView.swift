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
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if (card.isFaceUp) {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                Text(card.Content)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let lineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    let aspectRatio: CGFloat = 2/3
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * self.fontScaleFactor
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
