//
//  CardView.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-21.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct SetCardView: View {
    typealias SetGameCard = SetCard<SetGameViewModel.Shape, SetGameViewModel.Number, SetGameViewModel.Shading, SetGameViewModel.Color>
    
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
        .aspectRatio(cardAspectRatio, contentMode: .fit)
        .foregroundColor(convertColor(from: card.color))
        .padding(cardPadding)
        .scaleEffect(card.isSelected ? selectionScaling : 1.0)
        .rotation3DEffect(Angle.degrees(card.isSelected ? selectionDegree : 0), axis: (x: 1, y: 0, z: 1))
        .rotation3DEffect(Angle.degrees(card.isMatched ? 360 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func shape(for card: SetGameCard) -> some View {
        Group {
            if card.shape == .diamond {
                if card.shading == .open {
                    Diamond().stroke(lineWidth: lineWidth)
                } else {
                    Diamond()
                }
            } else if card.shape == .oval {
                if card.shading == .open {
                    Ellipse().stroke(lineWidth: lineWidth)
                } else {
                    Ellipse()
                }
            } else if card.shape == .rectangle {
                if card.shading == .open {
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                }
            }
        }
        .padding(.vertical, shapePadding)
        .aspectRatio(shapeAspectRatio, contentMode: .fit)
        .opacity(card.shading == .striped ? stripedOpacity : 1)
    }
    
    func convertColor(from color: SetGameViewModel.Color) -> Color {
        switch color {
        case .green: return SwiftUI.Color.green
        case .purple: return SwiftUI.Color.purple
        case .red: return SwiftUI.Color.red
        }
    }
    
    func convertNumber(from number: SetGameViewModel.Number) -> Int {
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
    
    let selectionDegree = 7.0
    let selectionScaling: CGFloat = 1.05
    let cardAspectRatio: CGFloat = 2/3
    let shapeAspectRatio: CGFloat = 3/2
    
    // This is a way of having all shapes be of the same size
    var horizontalExtraPaddingForShapes : CGFloat { 4*shapePadding }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardView(card: SetCard(shape: .diamond, number: .two, shading: .solid, color: .purple))
    }
}
