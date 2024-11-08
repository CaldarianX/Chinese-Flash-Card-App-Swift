import SwiftUI

struct FlashCardView: View {
    var deck: Deck
    @State private var currentQuestion: Int = 0
    @State private var showAnswer: Bool = false
    @State private var dragOffset: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.darkBlue
                .ignoresSafeArea()
            VStack {
                // Display the current question number
                HStack {
                    Spacer()
                    Text("\(currentQuestion + 1)/\(deck.cards.count)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .padding(.top, 20)
                
                Spacer()
                
                // Main card view with question and answer
                Button(action:
                    deck.cards[currentQuestion].SpeakQuestion
//                    print("Speaking")
                ){
                    Image(systemName: "speaker.wave.2.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .padding(8)
//                        .background(Color.blue)    // Optional: add background color
                        .clipShape(Circle())
                }
                VStack {
                    Text(deck.cards[currentQuestion].question)
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        .bold()
                    Text(deck.cards[currentQuestion].piyin)
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        .bold()
                    if showAnswer {
                        Text(deck.cards[currentQuestion].answer)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()  // Adds padding inside the card
                .frame(width: 350, height: 500)  // Adjusted height for better layout
                .background(Color.blue)  // Background color for the card
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(borderColor(), lineWidth: 4)  // Border with dynamic color
                )
                .rotationEffect(.degrees(Double(dragOffset.width / 20)))  // Adds rotation effect
                .offset(x: dragOffset.width)
                .gesture(
                    TapGesture()
                        .onEnded {
                            // Toggle answer visibility
                            withAnimation {
                                showAnswer.toggle()
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Update drag offset based on gesture
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            // Swipe left for next, swipe right for previous
                            if dragOffset.width < -100 {
                                withAnimation {
                                    deck.cards[currentQuestion].minusPoint(int: 20)
                                    nextCard()
                                }
                            } else if dragOffset.width > 100 {
                                // Swipe right (Previous card)
                                withAnimation {
                                    deck.cards[currentQuestion].addPoint(int: 10)
                                    nextCard()
                                }
                            }
                            dragOffset = .zero  // Reset drag offset
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
            // If out of questions, dismiss the view
            presentationMode.wrappedValue.dismiss()
        }
    }
    // Determines border color based on drag direction
    private func borderColor() -> Color {
        if dragOffset.width < -50 {
            return Color.red.opacity(Double(min(-dragOffset.width / 100, 1.0)))  // Fade red on left swipe
        } else if dragOffset.width > 50 {
            return Color.green.opacity(Double(min(dragOffset.width / 100, 1.0)))  // Fade green on right swipe
        } else {
            return Color.white
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
