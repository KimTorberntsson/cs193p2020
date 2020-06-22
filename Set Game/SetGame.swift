//
//  SetGame.swift
//  Set Game
//
//  Created by Kim Torberntsson on 2020-06-20.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import Foundation

struct SetGame<Shape, Number, Shading, Color> where
    Shape: CaseIterable, Shape: Equatable,
    Number: CaseIterable, Number: Equatable,
    Shading: CaseIterable, Shading: Equatable,
Color: CaseIterable, Color:  Equatable {
    typealias SetGameCard = SetCard<Shape, Number, Shading, Color>
    
    private var deck: [SetGameCard]
    private(set) var activeCards: [SetGameCard]
    
    init() {
        deck = [SetCard]()
        activeCards = [SetCard]()
        
        // Create a shuffled deck of every combination
        for shape in Shape.allCases {
            for number in Number.allCases {
                for shading in Shading.allCases {
                    for color in Color.allCases {
                        deck.append(SetCard(shape: shape, number: number, shading: shading, color: color))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    mutating func drawCard() {
        guard deck.count > 0 else {
            return
        }
        
        let index = Int.random(in: 0..<deck.count)
        let randomCard = deck.remove(at: index)
        activeCards.append(randomCard)
    }
    
    mutating func choose(card: SetGameCard) {
        guard activeCards.contains(card) && !card.isMatched else {
            return;
        }
        
        // Select or de-select the chosen card
        if let index = activeCards.firstIndex(of: card) {
            activeCards[index].isSelected.toggle()
            print("Selected card: \(card)")
        }
        
        let selectedCards = activeCards.filter { (card) in card.isSelected }
        if selectedCards.count < 3 {
            // We do not yet have three selected cards. Exit early
            return
        }
        
        if selectedCards.count == 3 {
            // We have exactly three selected cards. Do they match?
            if cardSetMatches(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2]) {
                
                // We have a match!
                activeCards[index(of: selectedCards[0])!].isMatched = true
                activeCards[index(of: selectedCards[1])!].isMatched = true
                activeCards[index(of: selectedCards[2])!].isMatched = true
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
            activeCards[index].isSelected = activeCards[index] == card
        }
    }
    
    // Selects and marks a set of cards as matched if there are any sets among the active cards.
    // Returns true if a set of cards was matched.
    mutating func cheat() {
        guard activeCards.count > 2 else {
            return
        }
        
        // Remove any selections
        for index in activeCards.indices {
            activeCards[index].isSelected = false
        }
        
        // Loop through all combinations and see if any matches
        for firstIndex in 0..<activeCards.count {
            for secondIndex in 1..<activeCards.count {
                if (secondIndex == firstIndex) {
                    continue
                }
                for thirdIndex in 2..<activeCards.count {
                    if (thirdIndex == firstIndex || thirdIndex == secondIndex) {
                        continue
                    }
                    if cardSetMatches(firstCard: activeCards[firstIndex], secondCard: activeCards[secondIndex], thirdCard: activeCards[thirdIndex]) {
                        // Found match. select and mark the cards as matched.
                        for index in [firstIndex, secondIndex, thirdIndex] {
                            activeCards[index].isSelected = true
                            activeCards[index].isMatched = true
                        }
                        return;
                    }
                }
            }
        }
        
        // Could not find match.
        return
    }
    
    private func index(of card: SetGameCard) -> Int? {
        activeCards.firstIndex(of: card)
    }
    
    private func cardSetMatches(firstCard: SetGameCard, secondCard: SetGameCard, thirdCard: SetGameCard) -> Bool {
        setMatches(first: firstCard.shape, second: secondCard.shape, third: thirdCard.shape) &&
        setMatches(first: firstCard.number, second: secondCard.number, third: thirdCard.number) &&
        setMatches(first: firstCard.shading, second: secondCard.shading, third: thirdCard.shading) &&
        setMatches(first: firstCard.color, second: secondCard.color, third: thirdCard.color)
    }
    
    // Returns true if the three types are set matching, meaning that they are either all the same or all different
    private func setMatches<T>(first: T, second: T, third: T) -> Bool where T: Equatable {
        first == second && second == third
            || first != second && first != third && second != third
    }
}
