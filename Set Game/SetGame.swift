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
        
        // Draw 12 cards from the deck and add to the active cards
        for _ in 0..<numberOfActiveCards {
            let index = Int.random(in: 0..<deck.count)
            let randomCard = deck.remove(at: index)
            activeCards.append(randomCard)
        }
    }
    
    mutating func choose(card: SetCard) {
        guard activeCards.contains(card) && !card.isMatched else {
            return;
        }
        
        // Select or de-select the chosen card
        if let index = activeCards.firstIndex(of: card) {
            activeCards[index].isSelected.toggle()
            print("Selected card: \(card)")
        }
        
        let selectedCardIndices = activeCards.indices.filter { (index) in activeCards[index].isSelected }
        if selectedCardIndices.count < 3 {
            // We do not yet have three selected cards. Exit early
            return
        }
        
        if selectedCardIndices.count == 3 {
            // We have exactly three selected cards. Do they match?
            let firstIndex = selectedCardIndices[0]
            let secondIndex = selectedCardIndices[1]
            let thirdIndex = selectedCardIndices[2]
            let firstCard = activeCards[firstIndex]
            let secondCard = activeCards[secondIndex]
            let thirdCard = activeCards[thirdIndex]
            if setMatches(first: firstCard.type, second: secondCard.type, third: thirdCard.type) &&
                setMatches(first: firstCard.number, second: secondCard.number, third: thirdCard.number) &&
                setMatches(first: firstCard.shading, second: secondCard.shading, third: thirdCard.shading) &&
                setMatches(first: firstCard.color, second: secondCard.color, third: thirdCard.color) {
                
                // We have a match!
                activeCards[firstIndex].isMatched = true
                activeCards[secondIndex].isMatched = true
                activeCards[thirdIndex].isMatched = true
            }
            
            return
        }
        
        // We have four selected cards.
        
        let matchedCardIndices = activeCards.indices.filter { (index) in activeCards[index].isMatched }
        for index in matchedCardIndices.reversed() {
            // Remove matched card
            activeCards.remove(at: index)
            
            if deck.count > 0 {
                // Add new card if there are cards left in the deck.
                let randomIndex = Int.random(in: 0..<deck.count)
                let randomCard = deck.remove(at: randomIndex)
                activeCards.insert(randomCard, at: index)
            }
        }
        
        // Deselect all cards except the newly chosen one
        for index in 0..<activeCards.count {
            activeCards[index].isSelected = activeCards[index].id == card.id
        }
    }
    
    // Returns true if the three types are set matching, meaning that they are either all the same or all different
    private func setMatches<T>(first: T, second: T, third: T) -> Bool where T: Equatable {
        first == second && second == third
            || first != second && first != third && second != third
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
        var isMatched = false
        
        static func == (lhs: SetCard, rhs: SetCard) -> Bool {
            lhs.type == rhs.type &&
                lhs.number == rhs.number &&
                lhs.shading == rhs.shading &&
                lhs.color == lhs.color
        }
        
        let id = UUID()
    }
}
