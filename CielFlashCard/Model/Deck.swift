//
//  Deck.swift
//  CielFlashCard
//
//  Created by Raphael on 25/10/24.
//

import Foundation
import SwiftData

@Model
final class Deck : Identifiable {
    var name: String
    var cards: [Card]
    var totalPlay : Int = 0
    init(name: String) {
        self.name = name
        self.cards = []
        self.totalPlay = 0
    }
    init (name: String, cards: [Card]) {
        self.name = name
        self.cards = cards
        self.totalPlay = 0
    }
    func addCard(_ card: Card) {
        cards.append(card)
    }
    func cardNumber() -> String {
        return String(cards.count)
    }
    func reviewNumber() -> String {
        return String(totalPlay)
    }
}
