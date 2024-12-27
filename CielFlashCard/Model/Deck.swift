//
//  Deck.swift
//  CielFlashCard
//
//  Created by Raphael on 25/10/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Deck : Identifiable {
    @Attribute(.unique) var name: String
    
    var Deckdescription: String = ""
    
    @Relationship(deleteRule : .cascade)
    var cards: [Card]
    
    @Attribute var color_deck : String = "Black"
    
    var totalPlay : Int = 0
    
    
    init(name: String) {
        self.name = name
        self.cards = []
        self.totalPlay = 0
    }
    init (name: String,des:String,color:Color) {
        self.name = name
        self.Deckdescription = des
        self.cards = []
        self.totalPlay = 0
        self.color_deck = saveColor(color: color)
    }
    init (name: String,cards:[Card]) {
        self.name = name
        self.cards = []
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
    func getColor() -> Color {
        switch color_deck {
            case "Black":
                return Color.black
            case "Red":
                return Color.red
            case "Green":
                return Color.green
            case "Blue":
                return Color.blue
            case "Yellow":
                return Color.yellow
            case "Purple":
                return Color.purple
            default:
                return Color.black
        }
    }
    func saveColor(color:Color)->String{
        switch color {
            case Color.black:
            color_deck = "Black"
                return color_deck
            case Color.red:
                color_deck = "Red"
                return color_deck
            case Color.green:
                color_deck = "Green"
                return color_deck
            case Color.blue:
                color_deck = "Blue"
                return color_deck
            case Color.yellow:
                color_deck = "Yellow"
                return color_deck
            case Color.purple:
                color_deck = "Purple"
                return color_deck
            default:
                color_deck = "Black"
                return color_deck
        }
    }
}


