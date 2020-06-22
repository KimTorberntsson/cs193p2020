//
//  ShapeSetGameView.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var shapeSetGame: SetGameWithShapes = SetGameWithShapes()
    
    var body: some View {
        GeometryReader { geometry in
            Grid(self.shapeSetGame.activeCards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                        self.shapeSetGame.choose(card: card)
                    }
                }
                .transition(.offset(self.shapeSetGame.getRandomOffset(for: geometry.size)))
            }
            .padding()
            .onAppear {
                withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                    for _ in 0..<12 {
                        self.shapeSetGame.drawCard()
                    }
                }
            }
        }
    }
    
    let cardSelectionResponse: Double = 0.7
    let cardSelectionDampingFraction: Double = 0.5
}
// MARK: - Content Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let view = ShapeSetGameView()
        let game = view.shapeSetGame
        game.choose(card: game.activeCards[2])
        game.choose(card: game.activeCards[4])
        return view
    }
}
