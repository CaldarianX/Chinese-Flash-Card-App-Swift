//
//  DeckCard.swift
//  CielFlashCard
//
//  Created by Raphael on 28/12/24.
//

import SwiftUI
import SwiftData

struct DeckCard: View {
    @Environment(\.dismiss) var dismiss
    @Binding var deck: Deck
    var body: some View {
        NavigationView{
            List{
                ForEach(deck.cards){card in
                    Text(card.question)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(deck.name)
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button{
                        print("Add")
                    }label: {
                        Text("Add")
                    }
                }
                ToolbarItem(placement:.topBarTrailing){
                    Button{
                        print("Play")
                    }label: {
                        Image(systemName: "play.fill")
                    }
                }
                ToolbarItem(placement : .topBarLeading){
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "arrow.backward")
                    }
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var previewDeck = Deck(name: "Preview Deck") // A sample Deck object
        
        var body: some View {
            DeckCard(deck: $previewDeck) // Pass the binding to the DeckCard view
        }
    }
    
    return PreviewWrapper()
}
