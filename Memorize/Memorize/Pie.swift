//
//  Pie.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-18.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct Pie : Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = true
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX,y: rect.midY)
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians)))
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise)
        path.addLine(to: center)
        
        return path
    }
}
