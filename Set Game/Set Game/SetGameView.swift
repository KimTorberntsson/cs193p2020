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
                self.titleRow()
                    .font(.title)
                    .padding(.top)
                self.cardGrid(for: geometry.size)
                    .padding(.horizontal)
                    .padding(.bottom)
                self.buttonRow()
                    .font(.title)
            }
        }
    }
    
    func titleRow() -> some View {
        HStack {
            Spacer()
            Text("Score: \(self.shapeSetGame.score)")
                .animation(nil)
            Spacer()
            Button(self.drawButtonText) {
                self.shapeSetGame.springAnimation {
                    self.shapeSetGame.drawAdditionalCards()
                }
            }
            .disabled(self.shapeSetGame.deckIsEmpty)
            Spacer()
        }
    }
    
    func buttonRow() -> some View {
        HStack {
            Spacer()
            Button(self.cheatButtonText) {
                self.shapeSetGame.springAnimation {
                    self.shapeSetGame.cheat()
                }
            }
            Spacer()
            Button(self.resetButtonText) {
                self.shapeSetGame.springAnimation {
                    self.shapeSetGame.reset()
                }
            }
            Spacer()
        }
    }
    
    func cardGrid(for size: CGSize) -> some View {
        Grid(shapeSetGame.activeCards) { card in
            SetCardView(card: card).onTapGesture {
                self.shapeSetGame.springAnimation {
                    self.shapeSetGame.choose(card: card)
                }
            }
            .padding(self.cardPadding)
            .transition(.offset(self.shapeSetGame.getRandomOffset(for: size)))
        }
        .onAppear {
            self.shapeSetGame.springAnimation {
                self.shapeSetGame.drawInitialCards()
            }
        }
    }
    
    let cardSelectionResponse: Double = 0.7
    let cardSelectionDampingFraction: Double = 0.5
    let cardPadding: CGFloat = 8
    let cheatButtonText = "Cheat"
    let drawButtonText = "Draw 3"
    let resetButtonText = "Reset"
}
// MARK: - Content Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
