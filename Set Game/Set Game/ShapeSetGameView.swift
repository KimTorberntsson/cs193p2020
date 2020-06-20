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
        }
    }
}

struct CardView: View {
    var card : SetGameCard
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
        }
        .foregroundColor(.orange)
        .padding(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
