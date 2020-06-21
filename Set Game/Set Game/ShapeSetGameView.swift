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
        Grid(shapeSetGame.activeCards) { card in
            CardView(card: card).onTapGesture {
                withAnimation(.spring(response: self.cardSelectionResponse, dampingFraction: self.cardSelectionDampingFraction)) {
                    self.shapeSetGame.choose(card: card)
                }
            }
        }
        .padding()
    }
    
    let cardSelectionResponse: Double = 0.7
    let cardSelectionDampingFraction: Double = 0.5
}

struct CardView: View {
    var card : SetGameCard
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
            VStack {
                ForEach(0..<self.convertNumber(from: self.card.number)) { _ in
                    self.shape(for: self.card)
                }
            }
            .padding(.horizontal, horizontalExtraPaddingForShapes)
            .padding(cardPadding)
        }
        .foregroundColor(convertColor(from: card.color))
        .padding(cardPadding)
        .scaleEffect(card.isSelected ? 1.05 : 1.0)
        .rotation3DEffect(Angle.degrees(card.isSelected ? 7 : 0), axis: (x: 1, y: 0, z: 1))
    }
    
    @ViewBuilder
    func shape(for card: SetGameCard) -> some View {
        Group {
            if card.type == .diamond {
                if card.shading == .open {
                    Diamond().stroke(lineWidth: lineWidth)
                } else {
                    Diamond()
                }
            } else if card.type == .oval {
                if card.shading == .open {
                    Ellipse().stroke(lineWidth: lineWidth)
                } else {
                    Ellipse()
                }
            } else if card.type == .rectangle {
                if card.shading == .open {
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                }
            }
        }
        .padding(.vertical, shapePadding)
        .aspectRatio(3/2, contentMode: .fit)
        .opacity(card.shading == .striped ? stripedOpacity : 1)
    }
    
    func convertColor(from color: SetGameWithShapes.Color) -> Color {
        switch color {
        case .green: return SwiftUI.Color.green
        case .purple: return SwiftUI.Color.purple
        case .red: return SwiftUI.Color.red
        }
    }
    
    func convertNumber(from number: SetGameWithShapes.Number) -> Int {
        switch(number) {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        }
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let lineWidth: CGFloat = 3
    let stripedOpacity = 0.3
    let cardPadding: CGFloat = 10
    let shapePadding: CGFloat = 3
    
    // This is a way of having all shapes be of the same size
    var horizontalExtraPaddingForShapes : CGFloat { 4*shapePadding }
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
