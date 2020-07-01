//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Kim Torberntsson on 2020-06-28.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if (uiImage != nil) {
                Image(uiImage: uiImage!)
            }
        }
    }
}
