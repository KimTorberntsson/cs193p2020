//
//  ShapeSetGameView.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var shapeSetGame: SetGameViewModel = SetGameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.buttonRow()
                    .font(.title)
                    .padding(.top)
                self.cardGrid(for: geometry.size)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
    
    func buttonRow() -> some View {
        HStack {
            Button(self.cheatButtonText) {
                withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                    self.shapeSetGame.cheat()
                }
            }
            Button(self.drawButtonText) {
                withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                    for _ in 0..<3 {
                        self.shapeSetGame.drawCard()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func cardGrid(for size: CGSize) -> some View {
        Grid(shapeSetGame.activeCards) { card in
            SetCardView(card: card).onTapGesture {
                withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                    self.shapeSetGame.choose(card: card)
                }
            }
            .padding(self.cardPadding)
            .transition(.offset(self.shapeSetGame.getRandomOffset(for: size)))
        }
        .onAppear {
            withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                for _ in 0..<12 {
                    self.shapeSetGame.drawCard()
                }
            }
        }
    }
    
    let cardSelectionResponse: Double = 0.7
    let cardSelectionDampingFraction: Double = 0.5
    let cardPadding: CGFloat = 8
    let cheatButtonText = "Cheat"
    let drawButtonText = "Draw 3"
}
// MARK: - Content Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
