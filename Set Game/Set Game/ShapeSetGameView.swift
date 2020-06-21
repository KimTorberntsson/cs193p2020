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
            CardView(card: card)
                .onTapGesture {
                    self.shapeSetGame.choose(card: card)
            }
        }
    }
}

struct CardView: View {
    var card : SetGameCard
    
    var body: some View {
        Group {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: lineWidth)
                VStack {
                    ForEach(0..<convertNumber(from: card.number)) { _ in
                        self.getView(from: self.card)
                    }
                }.padding()
            }
        }
        .foregroundColor(convertColor(from: card.color))
        .padding(cardPadding)
    }
    
    @ViewBuilder
    func getView(from card: SetGameCard) -> some View {
        VStack {
            if card.type == .diamond {
                if card.shading == .open {
                    Circle().stroke(lineWidth: 3)
                } else {
                    Circle()
                }
            } else if card.type == .oval {
                if card.shading == .open {
                    Ellipse().stroke(lineWidth: 3)
                } else {
                    Ellipse()
                }
            } else if card.type == .rectangle {
                if card.shading == .open {
                    Rectangle().stroke(lineWidth: 3)
                } else {
                    Rectangle()
                }
            }
        }
        .padding(shapePadding)
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
    let cardPadding: CGFloat = 5
    let shapePadding: CGFloat = 5
    
}

// MARK: - Content Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
