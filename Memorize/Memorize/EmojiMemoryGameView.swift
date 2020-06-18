//
//  ContentView.swift
//  EmojiMemoryGameView
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var memoryGame : EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("\(memoryGame.theme.name)")
                .font(Font.title)
                .padding()
            HStack {
                Button("Start New Game") { self.memoryGame.resetGameWithNewTheme() }
                    .padding(.horizontal)
                Text("Score: \(memoryGame.score)").scaledToFill()
                    .padding(.horizontal)
            }
            Grid(memoryGame.cards) { card in
                CardView(card: card).onTapGesture {
                    self.memoryGame.choose(card: card)
                }
            }
            .padding()
        }
        .foregroundColor(memoryGame.theme.color)
    }
        
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            if (card.isFaceUp) {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                Text(card.Content)
            } else {
                if (!card.isMatched) {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
        .padding(self.cardPadding)
    }
    
    // MARK: - Drawing Constants
    
    private let cardPadding : CGFloat = 7
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    private let aspectRatio: CGFloat = 2/3
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * self.fontScaleFactor
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(memoryGame: EmojiMemoryGame())
    }
}
