//
//  Diamond.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-21.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let topCenter = CGPoint(x: rect.midX, y: rect.minY)
        let leftMiddle = CGPoint(x: rect.minX, y: rect.midY)
        let middleBottom = CGPoint(x: rect.midX, y: rect.maxY)
        let rightMiddle = CGPoint(x: rect.maxX, y: rect.midY)
        
        var p = Path()
        p.move(to: topCenter)
        p.addLine(to: leftMiddle)
        p.addLine(to: middleBottom)
        p.addLine(to: rightMiddle)
        p.addLine(to: topCenter)
        
        return p;
    }
}
