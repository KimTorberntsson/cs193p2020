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
                Button(self.cheatButtonText) {
                    withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                        self.shapeSetGame.cheat()
                    }
                }
                .font(.title)
                .padding(.top)
                Grid(self.shapeSetGame.activeCards) { card in
                    SetCardView(card: card).onTapGesture {
                        withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                            self.shapeSetGame.choose(card: card)
                        }
                    }
                    .transition(.offset(self.shapeSetGame.getRandomOffset(for: geometry.size)))
                }
                .padding(.horizontal)
                .padding(.bottom)
                .onAppear {
                    withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                        for _ in 0..<12 {
                            self.shapeSetGame.drawCard()
                        }
                    }
                }
            }
        }
    }
    
    let cardSelectionResponse: Double = 0.7
    let cardSelectionDampingFraction: Double = 0.5
    let cheatButtonText = "Cheat"
}
// MARK: - Content Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
