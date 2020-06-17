//
//  MemoryGame.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    init(numberOfPairedCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairedCards {
            cards.append(Card(Content: cardContentFactory(pairIndex), id: pairIndex*2))
            cards.append(Card(Content: cardContentFactory(pairIndex), id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
        print("Card chosen \(card)")
        if let chosenIndex = cards.firstIndex(matching: card) {
            cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
        }
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var Content: CardContent
        var id : Int
    }
}
