//
//  ContentView.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct ShapeSetGameView: View {
    var body: some View {
        let game = SetGameWithShapes()
        return Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView()
    }
}
