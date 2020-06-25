//
//  SetCard.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-22.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

struct SetCard<Shape, Number, Shading, Color>: Equatable, Identifiable where
    Shape: CaseIterable, Shape: Equatable,
    Number: CaseIterable, Number: Equatable,
    Shading: CaseIterable, Shading: Equatable,
Color: CaseIterable, Color:  Equatable {
    
    var shape: Shape
    var number: Number
    var shading: Shading
    var color: Color
    
    var isSelected = false
    var matched = Matched.unmatched
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        lhs.shape == rhs.shape &&
            lhs.number == rhs.number &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color
    }
    
    let id = UUID()
    
    enum Matched {
        case matched
        case mismatched
        case unmatched
    }
}
