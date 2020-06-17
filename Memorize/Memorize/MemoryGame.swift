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
        let index = self.index(of: card)
        cards[index].isFaceUp = !cards[index].isFaceUp
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if (self.cards[index].id == card.id) {
                return index;
            }
        }
        return 0; // TODO: Bogus!
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var Content: CardContent
        var id : Int
    }
}
