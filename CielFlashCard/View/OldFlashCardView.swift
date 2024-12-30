import SwiftUI

struct FlashCardView: View {
    var deck: Deck
    @State private var currentQuestion: Int = 0
    @State private var showAnswer: Bool = false
    @State private var dragOffset: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("\(currentQuestion + 1)/\(deck.cards.count)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(Color.darkBlack2.opacity(0.8))
                .cornerRadius(10)
                .padding(.top, 20)
                
                Spacer()
                
                Button(action:
                    deck.cards[currentQuestion].SpeakQuestion
                ){
                    Image(systemName: "speaker.wave.2.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .padding(8)                     .clipShape(Circle())
                }
                VStack {
                    Text(deck.cards[currentQuestion].question)
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .foregroundColor(.black)//bg for question
                        .padding(.bottom, 10)
                        .bold()
                    Text(deck.cards[currentQuestion].piyin)
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.black)//bg for the piyin
                        .padding(.bottom, 10)
                        .bold()
                    if showAnswer {
                        Text(deck.cards[currentQuestion].answer)
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .frame(width: 350, height: 500)
                .background(Color.grayCard)//bg for card
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(borderColor(), lineWidth: 10)
                )
                .rotationEffect(.degrees(Double(dragOffset.width / 20)))
                .offset(x: dragOffset.width)
                .gesture(
                    
                    
                    TapGesture()
                        .onEnded {
                            
                            withAnimation {
                                showAnswer.toggle()
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            if dragOffset.width < -100 {
                                withAnimation {
                                    deck.cards[currentQuestion].minusPoint(int: 20)
                                    nextCard()
                                }
                            } else if dragOffset.width > 100 {
                                withAnimation {
                                    deck.cards[currentQuestion].addPoint(int: 10)
                                    nextCard()
                                }
                            }
                            dragOffset = .zero
                        }
                )
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    private func nextCard() {
        deck.totalPlay += 1
        if currentQuestion < deck.cards.count - 1 {
            currentQuestion += 1
            showAnswer = false
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
//    left red right green
    private func borderColor() -> Color {
        if dragOffset.width < -50 {
            return Color.red.opacity(Double(min(-dragOffset.width / 100, 1.0)))
        } else if dragOffset.width > 50 {
            return Color.green.opacity(Double(min(dragOffset.width / 100, 1.0)))
        } else {
            return Color.darkBlack2
        }
    }
}

#Preview {
    let sampleDeck = Deck(name: "Sample Deck", cards: [
        Card(question: "我喜欢学习", answer: "A UI framework by Apple."),
        Card(question: "苹果很好吃", answer: "A programming language by Apple."),
        Card(question: "我不会说中文", answer: "An IDE for Apple development."),
    ])
    FlashCardView(deck: sampleDeck)
}
