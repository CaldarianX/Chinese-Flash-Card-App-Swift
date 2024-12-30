//
//  PlayFlashCard.swift
//  CielFlashCard
//
//  Created by Raphael on 30/12/24.
//

import SwiftUI
import SwiftData

struct PlayFlashCard: View {
    @Environment(\.dismiss) var dismiss
    @Binding var deck : Deck
    @State private var currentIndex : Int = 0
    @State private var progress = 0.5
    @State private var showingAnswer = false
    @State private var offset = CGSize.zero
    @State private var finalOffset = CGSize.zero
    var body: some View {
        ProgressView(value : currentProgress())
            .frame(width: 330)
            .padding(.top,30)
            .tint(.green)
        Image(systemName: "speaker.wave.2.circle.fill")
            .resizable()
            .frame(width: 40,height: 40)
            .foregroundStyle(.gray)
            .onTapGesture {
                deck.cards[currentIndex].SpeakQuestion()
            }
            .padding(.vertical, 40)
//        Spacer()
        VStack{
            if showingAnswer {
                Text(deck.cards[currentIndex].answer)
                    .font(.title)
            }
            else{
                Text(deck.cards[currentIndex].question)
                    .font(.title)
            }
        }
        .frame(width: 320, height: 500)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor(), lineWidth: 3)
        )
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .offset(x:offset.width)
        
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                }
                .onEnded{_ in
                    finalOffset = offset
                    offset = CGSize.zero
                    NextCard()
                }
        )
        .onTapGesture {
            withAnimation{
                showingAnswer.toggle()
            }
        }
        Spacer()
    }
    private func NextCard(){
        if finalOffset.width > 30{
            deck.cards[currentIndex].point += 10
        }
        else{
            deck.cards[currentIndex].point -= 15
        }
        showingAnswer = false
        if currentIndex < deck.cards.count - 1 {
            currentIndex += 1
        } else {
            dismiss() // Dismiss when there are no more cards
        }
        
    }
    private func borderColor() -> Color {
        if offset.width < -30 {
            return Color.red.opacity(Double(min(-offset.width / 100, 1.0)))
        } else if offset.width > 30 {
            return Color.green.opacity(Double(min(offset.width / 100, 1.0)))
        } else {
            return Color.darkBlack2
        }
    }
    private func currentProgress() -> Double {
        Double(currentIndex+1) / Double(deck.cards.count)
    }
}
#Preview {
    PlayFlashCardPreviewWrapper()
}

struct PlayFlashCardPreviewWrapper: View {
    @State private var deck = Deck(name: "Test Deck", cards: [
        Card("Question 1", "Answer 1"),
        Card("Question 2", "Answer 2"),
        Card("Question 3", "Answer 3")
    ])

    var body: some View {
        PlayFlashCard(deck: $deck)
    }
}


//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Deck.self, configurations: config)
//    
//    var cards = [
//        Card("Test1", "ANS1"),
//        Card("Test2", "ANS2"),
//        Card("Test3", "ANS3")
//    ]
//    let newDeck = Deck(name: "Test", cards: cards)
//    container.mainContext.insert(newDeck)
//    
//    return StatePreviewWrapper(deck: newDeck)
//}

