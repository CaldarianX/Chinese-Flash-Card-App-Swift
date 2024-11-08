//
//  PlaySetting.swift
//  CielFlashCard
//
//  Created by Raphael on 30/10/24.
//

import SwiftUI

struct PlaySetting: View {
    var deck: Deck
    var body: some View {
        ZStack{
            Color.darkBlue
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("Mode")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal,30)
                        .bold()
                    Spacer()
                }
                ModeOption(OptionName: "FlashCard", OptionColor: Color.blue)
                ModeOption(OptionName: "Choice", OptionColor: Color.red)
            }

        }
    }
}
struct ModeOption : View {
    var OptionName : String
    var OptionColor : Color
    var body: some View {
        HStack{
            Text(OptionName)
                .font(.title2)
                .foregroundColor(.white)
                .bold()
                .frame(width:200, height: 50)
                .background(Color.darkBlue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .border(OptionColor, width: 5)
            Spacer()
        }
        .padding(.horizontal,30)
    }
}

#Preview {
    let sampleDeck = Deck(name: "Sample Deck", cards: [
        Card(question: "What is SwiftUI?", answer: "A UI framework by Apple."),
        Card(question: "What is Swift?", answer: "A programming language by Apple."),
        Card(question: "What is Xcode?", answer: "An IDE for Apple development."),
    ])
    PlaySetting(deck: sampleDeck)
}
