import SwiftUI
import SwiftData

enum Mode {
    case FlashCard
    case MultipleChoice
}
struct DeckView: View {
    var deck: Deck  // Deck passed from ContentView
    @State private var newQuestion: String = ""
    @State private var newAnswer: String = ""
    @State private var Ondelete: Bool = false
    @State private var AddInBulk : Bool = false
    @State private var BulkString : String = ""
    @State private var SelectedCard : String = ""
    @State private var SelectedAmountCard : Int = 20
    @State private var IsShuffle : Bool = false
    @State private var SelectedMode : Mode = Mode.FlashCard
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text(deck.name)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()

                    DeckInfo(text1: "Total Cards:", text2: deck.cardNumber())
                    DeckInfo(text1: "Total Reviews:", text2: deck.reviewNumber())
                    
                    Button(action: {
                        withAnimation{
                            Ondelete.toggle()  // Toggle the state
                        }
                    }) {
                        HStack {
                            Text("Delete")
                                .font(.title3)
//                                .padding(.leading)
                                .foregroundColor(.white)
                        }
                        .frame(width: 320, height: 20)
                        .padding(.vertical)
                        .background(.darkBlack2)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.3), lineWidth:2))
                    }
                    Button(action: {
                        withAnimation{
                            AddInBulk.toggle() // Toggle the state
                        }
                    }) {
                        HStack {
                            Text(AddInBulk ? "Add in bulk" : "Add One by One")
                                .font(.title3)
                                .padding(.leading)
                                .foregroundColor(.white)
                        }
                        .frame(width: 320, height: 20)
                        .padding(.vertical)
                        .background(.darkBlack2)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.3), lineWidth:2))
                        .padding(.bottom,20)
                    }
                    if !AddInBulk{
                        AddCardView(question: $newQuestion, answer: $newAnswer, onAdd: addCard)
                            .padding(.bottom, 20)
                    }
                    else{
                        AddInBulkCard(BulkString: $BulkString, AddInBulk: addCardInBulk)
                            .padding(.bottom, 20)
                    }
                    NavigationLink(destination: FlashCardView(deck: deck)) {
                        HStack {
                            Text("Play")
                                .font(.title3)
//                                .padding(.leading)
                                .foregroundColor(.white)
                        }
                        .frame(width: 320, height: 20)
                        .padding(.vertical)
                        .background(.darkBlack2)
                        .bold()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top,20)
                    VStack(spacing: 20) {
                        HStack{
                            Text("Select Mode")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal,40)
                        // FlashCard Button
                        Button("FlashCard") {
                            SelectedMode = .FlashCard
                        }
                        .frame(width: 320, height: 50)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(SelectedMode == .FlashCard ? Color.red : Color.gray, lineWidth: 4) // Change border color
                        )
                        .bold()

                        // Multiple Choice Button
                        Button("Multiple Choice") {
                            SelectedMode = .MultipleChoice
                        }
                        .frame(width: 320, height: 50)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(SelectedMode == .MultipleChoice ? Color.green : Color.gray, lineWidth: 4) // Change border color
                        )
                        .bold()
                    }
                    HStack{
                        Text("Review Amount")
                            .font(.title3)
                            .foregroundStyle(.white)
//                            .padding(.leading,50)
                            
                        Picker(selection:$SelectedAmountCard, label: Text("Review Amount")) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("15").tag(15)
                            Text("20").tag(20)
                            Text("30").tag(30)
                            Text("40").tag(40)
                            Text("All").tag(deck.cards.count)
                        }
                        .foregroundColor(.white)
//                        .frame(width: 300, height: 40)   // Control the picker size
                        .background(Color.white)
                        .cornerRadius(8)                 // Rounded corners
                        .shadow(radius: 4)
                        .padding(.leading,80)
                        Spacer()
                    }
                    .padding(.horizontal,50)
                    HStack{
                        Toggle("Shuffle", isOn: $IsShuffle)
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.horizontal,50)
                    }
                    HStack {
                        Picker(selection:$SelectedCard, label: Text("Picker")) {
                            Text("All").tag("All")
                            Text("A").tag("A")
                            Text("B").tag("B")
                            Text("C").tag("C")
                            Text("D").tag("D")
                            Text("E").tag("E")
                            Text("F").tag("F")
                        }
                        .pickerStyle(.segmented)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 40)   // Control the picker size
                        .background(Color.white)
                        .cornerRadius(8)                 // Rounded corners
                        .shadow(radius: 4)
                        .padding(.bottom,30)                       // Padding around the picker
                        
                    }
                    .padding(.horizontal,40)
                    
                    if !deck.cards.isEmpty {
                        ForEach(deck.cards
                            .filter { card in
                                SelectedCard == "All" || card.getGrade() == SelectedCard
                            }
                            .sorted(by: { $0.point > $1.point })
                        ) { card in
                            CardView(card: card, deck: deck, Ondelete: Ondelete)
                                .padding(.bottom, 10)
                        }
                    } else {
                        Text("No cards available in this deck")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .background(Color.clear)
            }
        }
        .toolbarBackground(.darkBlue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    func addCard() {
        let newCard = Card(question: newQuestion, answer: newAnswer)
        deck.cards.append(newCard)  // Add new card to deck
        newQuestion = ""  // Reset input fields
        newAnswer = ""
    }
    func addCardInBulk() {
        let cards =  BulkString.components(separatedBy: .newlines)
        for card in cards {
            let text = card.components(separatedBy: ",")
            let question = text[0]
            let answer = text[2]
            let newCard = Card(question: question, answer: answer)
            deck.cards.append(newCard)
        }
    }
}

struct AddCardView: View {
    @Binding var question: String
    @Binding var answer: String
    var onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text("Q:")
                        .font(.title)
                    TextField("QUESTION", text: $question)
                        .font(.title)
                    Spacer()
                }
                HStack {
                    Text("A:")
                        .font(.title)
                        .padding(.leading, 3)
                    TextField("ANSWER", text: $answer)
                        .font(.title)
                    Spacer()
                }
            }
            .padding(.leading)
        }
        .frame(width: 320, height: 150)
        .background(.white)  // Card background color
        .cornerRadius(10)
        .shadow(radius: 5)
        
        HStack {
            Spacer()
            Button("Clear") {
                question = ""
                answer = ""
            }
            .font(.title3)
            .foregroundStyle(.white)
            .frame(width: 150, height: 50)
            .background(.darkBlack2)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
            Button("Add") {
                onAdd()
            }
            .font(.title3)
            .foregroundStyle(.white)
            .frame(width: 150, height: 50)
            .background(.darkBlack2)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            Spacer()
        }
    }
}

struct AddInBulkCard : View {
    @Binding var BulkString : String
    var AddInBulk: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                TextEditor(text: $BulkString)
            }
            .padding(.leading)
        }
        .frame(width: 320, height: 450)
        .background(.white)  // Card background color
        .cornerRadius(10)
        .shadow(radius: 5)
        
        HStack {
            Spacer()
            Button("Clear") {
                BulkString = ""
            }
            .font(.title3)
            .foregroundStyle(.white)
            .frame(width: 150, height: 50)
            .background(.darkBlack2)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
            Button("Add") {
                AddInBulk()
            }
            .font(.title3)
            .foregroundStyle(.white)
            .frame(width: 150, height: 50)
            .background(.darkBlack2)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            Spacer()
        }
    }
}
struct CardView: View {
    let card: Card
    var deck: Deck
    var Ondelete: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                if Ondelete {
                    Button(action: {
                        withAnimation {
                            deck.cards.removeAll { $0.id == card.id }
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                HStack {
                    Text("Q:")
                        .font(.title)
                    Text(card.question)
                        .font(.title)
                    Spacer()
                }
                HStack {
                    Text("A:")
                        .font(.title)
                        .padding(.leading, 3)
                    Text(card.answer)
                        .font(.title)
                    Spacer()
                }
            }
            .padding(.top, 20)
            .padding(.leading)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(card.getGrade())
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                Spacer()
            }
            .frame(height: 50)
            .background(card.getColor())
        }
        .frame(width: 320, height: 150)
        .background(.white)  // Card background color
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct DeckInfo: View {
    let text1: String
    let text2: String
    
    var body: some View {
        HStack {
            Text(text1)
                .font(.title3)
                .padding(.leading)
                .foregroundColor(.white)
            Spacer()
            Text(text2)
                .font(.title3)
                .padding(.trailing, 20)
                .foregroundColor(.white)
                .bold()
        }
        .frame(width: 320, height: 20)
        .padding(.vertical)
        .background(.darkBlack2)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    let sampleDeck = Deck(name: "Sample Deck", cards: [
        Card(question: "你好", answer: "A UI framework by Apple."),
        Card(question: "书", answer: "A programming language by Apple."),
        Card(question: "What is Xcode?", answer: "An IDE for Apple development."),
    ])
    DeckView(deck: sampleDeck)
}

