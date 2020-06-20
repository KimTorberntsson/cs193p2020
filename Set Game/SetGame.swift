//
//  SetGame.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

struct SetGame<Type, Number, Shading, Color> where
    Type: CaseIterable, Type: Equatable,
    Number: CaseIterable, Number: Equatable,
    Shading: CaseIterable, Shading: Equatable,
Color: CaseIterable, Color:  Equatable {
    typealias SetCard = Card<Type, Number, Shading, Color>
    
    private let numberOfActiveCards = 12
    private var deck: [SetCard]
    private(set) var activeCards: [SetCard]
    
    init() {
        deck = [SetCard]()
        activeCards = [SetCard]()
        
        // Create a shuffled deck of every combination
        for type in Type.allCases {
            for number in Number.allCases {
                for shading in Shading.allCases {
                    for color in Color.allCases {
                        deck.append(Card(type: type, number: number, shading: shading, color: color))
                    }
                }
            }
        }
        deck.shuffle()
        
        // Pick 12 cards from the deck and add to the cards
        for _ in 0..<numberOfActiveCards {
            drawRandomCard()
        }
    }
    
    mutating func choose(card: SetCard) {
        guard activeCards.contains(card) else {
            return;
        }
        
        if let index = activeCards.firstIndex(of: card) {
            activeCards[index].isSelected = true
            print("Selected card: \(card)")
        }
    }
    
    // Draws a random card from the deck and adds it to the active cards
    private mutating func drawRandomCard() {
        let index = Int.random(in: 0..<deck.count)
        let randomCard = deck.remove(at: index)
        activeCards.append(randomCard)
    }
    
    // Represents a card in the set game
    struct Card<Type, Number, Shading, Color>: Equatable, Identifiable where
        Type: CaseIterable, Type: Equatable,
        Number: CaseIterable, Number: Equatable,
        Shading: CaseIterable, Shading: Equatable,
    Color: CaseIterable, Color:  Equatable {
        typealias SetCard = SetGame<Type, Number, Shading, Color>.Card<Type, Number, Shading, Color>
        
        var type: Type
        var number: Number
        var shading: Shading
        var color: Color
        
        var isSelected = false
        
        static func == (lhs: SetCard, rhs: SetCard) -> Bool {
            lhs.type == rhs.type &&
                lhs.number == rhs.number &&
                lhs.shading == rhs.shading &&
                lhs.color == lhs.color
        }
        
        let id = UUID()
    }
}
