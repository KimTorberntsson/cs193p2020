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
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if (card.isFaceUp || !card.isMatched) {
            ZStack {
                Pie(startAngle: startAngle, endAngle: endAngle)
                    .padding(cardPadding)
                    .opacity(opacity)
                Text(card.Content)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .font(Font.system(size: fontSize(for: size)))
            .padding(self.cardPadding)
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cardPadding : CGFloat = 5
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.65
    private let aspectRatio: CGFloat = 2/3
    
    private let startAngle = Angle(degrees: 0-90)
    private let endAngle = Angle(degrees: 120-90)
    private let opacity = 0.35
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * self.fontScaleFactor
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        game.choose(card: game.cards[2])
        return EmojiMemoryGameView(memoryGame: game)
    }
}
