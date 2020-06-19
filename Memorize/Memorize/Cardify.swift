//
//  Cardify.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-18.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct Cardify : AnimatableModifier {
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if (isFaceUp) {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
