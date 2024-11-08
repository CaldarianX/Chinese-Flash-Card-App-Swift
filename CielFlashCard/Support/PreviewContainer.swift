//
//  PreviewContainer.swift
//  CielFlashCard
//
//  Created by Raphael on 25/10/24.
//

import Foundation
import SwiftData

// Sample data with multiple decks and cards
let sampleDecks = [
    Deck(name: "Sample Deck 1", cards: [
        Card(question: "Q1 in Deck 1", answer: "A1"),
        Card(question: "Q2 in Deck 1", answer: "A2")
    ]),
    Deck(name: "Sample Deck 2", cards: [
        Card(question: "Q1 in Deck 2", answer: "A1"),
        Card(question: "Q2 in Deck 2", answer: "A2")
    ]),
    Deck(name: "Sample Deck 3", cards: [
        Card(question: "Q1 in Deck 3", answer: "A1"),
        Card(question: "Q2 in Deck 3", answer: "A2"),
        Card(question: "Q3 in Deck 3", answer: "A3")
    ])
]

// Model container setup
@MainActor
let previewContainer: ModelContainer = {
    do {
        // Create the ModelContainer in memory for Deck and Card models
        let container = try ModelContainer(for: Deck.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Insert multiple sample decks into the main context
        for deck in sampleDecks {
            container.mainContext.insert(deck)
        }
        
        // Return the container after inserting sample data
        return container
    } catch {
        fatalError("Could not load preview container: \(error)")
    }
}()
