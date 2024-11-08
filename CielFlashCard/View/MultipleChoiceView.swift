import SwiftUI

struct MultipleChoiceView: View {
    var deck: Deck
    @State private var currentQuestion: Int = 0
    @State private var showAnswer: Bool = false
    @State private var selectChoice: Int = 0
    @State private var correctAnswer: Int = 1
    @State private var answerHighlightColor: Color = .white
    @State private var isAnswerHighlighted: Bool = false
    @State private var isShowPiyin: Bool = false
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
                .background(Color.lightDarkBlue.opacity(0.8))
                .cornerRadius(10)
                .padding(.top, 20)
                
                Spacer()
                
                // Main card view with question and answer
                VStack {
                    Text(deck.cards[currentQuestion].question)
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    if isShowPiyin{
                        Text(deck.cards[currentQuestion].piyin)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    
                    // Multiple choice options
                    VStack {
                        ForEach(1...4, id: \.self) { choiceNumber in
                            Choice(
                                selectedChoice: $selectChoice,
                                choiceNumber: choiceNumber,
                                isSelected: choiceNumber == selectChoice
                            )
                        }
                        
                        // Submit button to check the answer
                        Button("Submit") {
                            checkAnswer()
                        }
                        .frame(width: 320, height: 50)
                        .foregroundColor(.white)
                        .background(Color.darkPurple)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .padding()
                .frame(width: 350, height: 500)
                .background(Color.lightDarkBlue)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(answerHighlightColor, lineWidth: 4)
                )
                Spacer()
            }
            .padding(.horizontal)
        }
    }

    // Checks if the selected choice is correct and sets the highlight color
    private func checkAnswer() {
        if selectChoice == correctAnswer {
            answerHighlightColor = .green  // Correct answer
        } else {
            answerHighlightColor = .red  // Incorrect answer
        }
        isAnswerHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isAnswerHighlighted = false
            answerHighlightColor = .white
            nextCard()
        }
    }

    private func nextCard() {
        deck.totalPlay += 1
        selectChoice = 0
        if currentQuestion < deck.cards.count - 1 {
            currentQuestion += 1
            showAnswer = false
        } else {
            // If out of questions, dismiss the view
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Choice View with a highlighted border
struct Choice: View {
    @Binding var selectedChoice: Int
    var choiceNumber: Int
    var isSelected: Bool

    var body: some View {
        Button("Choice \(choiceNumber)") {
            selectedChoice = choiceNumber
        }
        .frame(width: 320, height: 50)
        .foregroundColor(.white)
        .background(.darkBlue)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.white : Color.darkBlue, lineWidth: 4)
        )
        .shadow(color: isSelected ? Color.red.opacity(0.4) : Color.clear, radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

#Preview {
    let sampleDeck = Deck(name: "Sample Deck", cards: [
        Card(question: "我喜欢学习", answer: "A UI framework by Apple."),
        Card(question: "苹果很好吃", answer: "A programming language by Apple."),
        Card(question: "我不会说中文", answer: "An IDE for Apple development."),
    ])
    MultipleChoiceView(deck: sampleDeck)
}

