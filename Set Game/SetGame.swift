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
    
    private(set) var deck: [SetGameCard] = [SetCard]()
    private(set) var activeCards: [SetGameCard] = [SetCard]()
    private(set) var score = 0
    
    private let initialCardNumber = 12
    private let additionalCardNumber = 3
    
    init() {
        createDeck()
    }
    
    mutating func drawInitialCards() {
        for _ in 0..<initialCardNumber {
            drawCard()
        }
    }
    
    mutating func drawAdditionalCards() {
        if activeCards.filter({ card in card.matched == .matched }).count == 3 {
            removeMatchingCardsAndDrawNew()
        } else {
            for _ in 0..<additionalCardNumber {
                drawCard()
            }
        }
    }
    
    mutating func choose(card newCard: SetGameCard) {
        guard activeCards.contains(newCard) else {
            return;
        }
        
        print("Selected card: \(newCard)")
        
        // Replace matching cards if there are any
        removeMatchingCardsAndDrawNew()
        
        if !activeCards.contains(newCard) {
            // The new card was matched and removed. Exit early.
            return
        }
        
        let newCardIndex = index(of: newCard)!
        let selectedCards = activeCards.filter { (card) in card.isSelected }
        if selectedCards.count == 2 && !selectedCards.contains(newCard) {
            // We have two previously selected cards and the new card is not one of them.
            // This means that we can match the selection.
            if cardSetMatches(firstCard: newCard, secondCard: selectedCards[0], thirdCard: selectedCards[1]) {
                
                // We have a match!
                activeCards[newCardIndex].matched = .matched
                activeCards[index(of: selectedCards[0])!].matched = .matched
                activeCards[index(of: selectedCards[1])!].matched = .matched
                score += 3
            } else {
                // We have a mismatch
                activeCards[newCardIndex].matched = .mismatched
                activeCards[index(of: selectedCards[0])!].matched = .mismatched
                activeCards[index(of: selectedCards[1])!].matched = .mismatched
                score -= 1
            }
        }
        
        // Deselect all other cards if we are about to select a forth card
        if (selectedCards.count == 3) {
            for cardIndex in activeCards.indices {
                activeCards[cardIndex].isSelected = false
                activeCards[cardIndex].matched = .unmatched
            }
        }
        
        // Toggle selection of new card
        activeCards[newCardIndex].isSelected.toggle()
    }
    
    // Selects and marks a set of cards as matched if there are any sets among the active cards.
    // Returns true if a set of cards was matched.
    mutating func cheat() {
        guard activeCards.count > 2 else {
            return
        }
        
        if activeCards.filter({ card in card.matched == .matched }).count == 3 {
            removeMatchingCardsAndDrawNew()
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
                            activeCards[index].matched = .matched
                        }
                        return;
                    }
                }
            }
        }
        
        // Could not find match.
        return
    }
    
    mutating func reset() {
        self.deck = [SetGameCard]()
        self.activeCards = [SetGameCard]()
        self.score = 0
        
        createDeck()
        drawInitialCards()
    }
    
    private mutating func createDeck() {
        // Create a shuffled deck of every card combination
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
    
    private mutating func drawCard() {
        guard deck.count > 0 else {
            return
        }
        
        let index = Int.random(in: 0..<deck.count)
        let randomCard = deck.remove(at: index)
        activeCards.append(randomCard)
    }
    
    private mutating func removeMatchingCardsAndDrawNew() {
        let matchedCardIndices = activeCards.indices.filter { (index) in activeCards[index].matched == .matched }
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
