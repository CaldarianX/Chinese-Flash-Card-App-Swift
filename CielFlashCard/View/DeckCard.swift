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
    @State var AddCardSheet = false
    @Binding var deck: Deck
    @State private var alertMessage : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        NavigationView{
            List{
                ForEach(deck.cards) { card in
                    CardUI(card: card)
                        .swipeActions {
                            Button("Delete") {
                                removeCard(card: card)
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(deck.name)
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button{
                        print("Add")
                        AddCardSheet = true
                    }label: {
                        Text("Add")
                    }
                    .sheet(isPresented: $AddCardSheet){
                        AddNewCard(isPresented: $AddCardSheet, addCard: addCard, addCardInBulk: addCardInBulk)
                    }
                    .alert("Error", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(alertMessage)
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
    func removeCard(card: Card) {
        if let index = deck.cards.firstIndex(where: { $0.id == card.id }) {
            deck.cards.remove(at: index)
        }
    }
    func addCard(question:String,answer:String){
        let NewCard = Card(question,answer)
        deck.addCard(NewCard)
    }
    func addCardInBulk(InbulkString:String,separator:String){
        print("HELLO")
        let lines = InbulkString.split(separator: "\n")
//        InBulkArray.forEach{InBulkString in
        for (index, line) in lines.enumerated(){
            let words = line.split(separator: separator,maxSplits:1)
            if(words.count == 2){
                let Question = String(words[0])
                let Answer = String(words[1])
                addCard(question: Question, answer: Answer)
            }
            else {
                // Trigger the alert for a line with incorrect format
                alertMessage = "Error on line \(index + 1): \"\(line)\" does not match the required format."
                showAlert = true
                return // Stop processing further lines
            }
        }
    }
}
struct AddNewCard : View {
    @State private var AddInBulk = false
    @State private var Question:String = ""
    @State private var Answer:String = ""
    @State private var InBulkString:String = ""
    @State private var Separator:String = ""
    @Binding var isPresented:Bool
    var addCard : (String,String)->Void
    var addCardInBulk : (String,String)->Void
    
    var body: some View {
        Form{
            
            Section{
                Toggle(isOn: $AddInBulk) {
                    Text("Add In Bulk")
                        .foregroundStyle(.black)
                }
                .tint(.blue)
            }
            if !AddInBulk{
                Section{
                    TextField("Question",text:$Question)
                    TextField("Answer",text:$Answer)
                } header: {
                    Text("Card")
                }
            }
            if AddInBulk{
                Section{
                    TextEditor(text:$InBulkString)
                } header: {
                    Text("Cards")
                }
                Section{
                    TextField("",text:$Separator)
                } header:{
                    Text("Separator")
                }
            }
        }
        Button("Add") {
//            print("We are adding")
//            print(AddInBulk)
            if AddInBulk{
//                print("ERER2")
//                print(InBulkString)
//                print(Separator)
                if !InBulkString.isEmpty && !Separator.isEmpty{
//                    print("HERE")
                    addCardInBulk(InBulkString,Separator)
                }
            }
            else{
                if !Question.isEmpty && !Answer.isEmpty{
                    addCard(Question,Answer)
                }
            }
            isPresented = false
        }
    }
}

struct CardUI :View {
    @State var card : Card
    var body: some View {
        HStack{
            Text(card.question)
//                .foregroundStyle(.gray)
            Spacer()
            Text(card.answer)
                .foregroundStyle(.gray)
            Text(card.getGrade())
                .padding(8) // Add inner spacing
                .background(card.getColor()) // Set the background color
                .foregroundColor(.white) // Optional: Make the text color stand out
                .clipShape(Capsule()) // Make the background rounded
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
