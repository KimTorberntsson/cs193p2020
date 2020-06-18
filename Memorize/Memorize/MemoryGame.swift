//
//  MemoryGame.swift
//  Memorize
//
//  Created by Kim Torberntsson on 2020-06-16.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    var mismatchedCardIndices: [Int]
    var score: Int = 0
    
    var indexOfTheOnlyFaceUpCard: Int? {
        get { cards.indices.filter { (index) in cards[index].isFaceUp }.only }
        set {
            for index in 0..<cards.count {
                cards[index].isFaceUp = newValue == index
            }
        }
    }
    
    init(numberOfPairedCards: Int, cardContentFactory: (Int) -> CardContent) {
        mismatchedCardIndices = [Int]()
        cards = [Card]()
        for pairIndex in 0..<numberOfPairedCards {
            cards.append(Card(Content: cardContentFactory(pairIndex), id: pairIndex*2))
            cards.append(Card(Content: cardContentFactory(pairIndex), id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
        print("Card chosen \(card)")
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].Content == cards[potentialMatchIndex].Content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    if !mismatchedCardIndices.contains(chosenIndex) {
                        mismatchedCardIndices.append(chosenIndex)
                        score -= 1
                    }
                    if !mismatchedCardIndices.contains(potentialMatchIndex) {
                        mismatchedCardIndices.append(potentialMatchIndex)
                        score -= 1
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    struct Card : Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var Content: CardContent
        var id : Int
    }
}
