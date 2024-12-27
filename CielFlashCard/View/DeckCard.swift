//
//  DeckCard.swift
//  CielFlashCard
//
//  Created by Raphael on 28/12/24.
//

import SwiftUI
import SwiftData

struct DeckCard: View {
    @Binding var deck: Deck
    var body: some View {
        Text("\(deck.name)")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self,configurations: config)
    container.mainContext.insert(Deck(name: "Test Deck"))
    
}
