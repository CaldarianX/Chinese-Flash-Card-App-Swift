import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var decks : [Deck]
    @State var IsRemove  : Bool = false
    @State var newDeskName  : String = ""
    var body: some View {
        NavigationStack{
            HStack{
                Text("Decks")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                NavigationStack {
                    NavigationLink(destination: NewDeckInfo(onSave: { name, description, color in
                        addNewDeck(name: name, description: description, color: color)
                    })) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .frame(width: 20,height: 20)
                Image(systemName: "minus")
                    .font(.title)
                    .foregroundColor(.blue)
                    .onTapGesture{
                        withAnimation{
                            IsRemove.toggle()
                        }
                    }
            }
            .padding(.horizontal,50)
            ScrollView{
                ForEach(decks){deck in
                    HStack{
                        NavigationLink(destination: DeckView(deck: deck)) {
                            DeckUI(deck: deck)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        }
                        if IsRemove {
                            Button(action: {
                                withAnimation {
                                    modelContext.delete(deck)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }

    }
    func addNewDeck(name: String, description: String, color: Color) {
        let newDeck = Deck(name: name, des: description,color:color)
        withAnimation {
            modelContext.insert(newDeck)
        }
    }
}
struct NewDeckInfo : View{
    @Environment(\.dismiss) var dismiss
    @State var name : String = ""
    @State var des : String = ""
    @State var selectedColor: Color = .blue // Default color
    var onSave: (String, String, Color) -> Void
    
    let colorOptions: [Color] = [.blue, .red, .green, .yellow, .purple]
    
    var body : some View {
        Form{
            Section{
                TextField("Name",text:$name)
                TextField("Description",text:$des)
            } header: {
                Text("Deck")
            }
            Section {
                Text("Pick a Color")
                HStack {
                    ForEach(colorOptions, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                withAnimation{
                                    selectedColor = color
                                }
                            }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(Text("New Deck"))
        Button("Add Deck") {
            onSave(name,des,selectedColor)
            dismiss()
        }
    }
}
struct DeckUI : View {
    let deck : Deck
    var body: some View {
        VStack{
            HStack{
                Text(deck.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
            }
            HStack{
                Text(deck.Deckdescription)
                .font(.caption)
                .bold()
                .foregroundStyle(.white)
                Spacer()
            }
            Spacer()
            HStack{
                Text("Total Play : \(deck.totalPlay)")
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
                Text("Total Cards : \(deck.cardNumber())")
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
        .frame(width: 300,height: 120)
        .background(deck.getColor())
        .cornerRadius(5)
        .frame(width: 300)
    }
}
#Preview {
    ContentView()
        .modelContainer(previewContainer)
}



