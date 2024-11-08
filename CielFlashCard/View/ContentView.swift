import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var decks : [Deck]
    @State var IsRemove  : Bool = false
    @State var newDeskName  : String = ""
    var body: some View {
        NavigationStack{
            Text("Decks")
                .font(.largeTitle)
                .bold()
            HStack{
                Spacer()
                Button("Add") {
                    withAnimation{
                        if(newDeskName != ""){
                            modelContext.insert(Deck(name: newDeskName))
                            newDeskName = ""
                        }
                    }
                }
                .frame(width: 100,height: 50)
                .background(.black)
                .cornerRadius(10)
                .foregroundStyle(.white)
                .bold()
                TextField(
                    "new Deck Name",
                    text: $newDeskName
                )
                .frame(width: 100,height :40)
                Spacer()
            }
            Button("Remove") {
                withAnimation{
                    IsRemove.toggle()
                }
            }
            
            .frame(width: 100,height: 50)
            .background(.white)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .bold()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 5))
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
}

struct DeckUI : View {
    let deck : Deck
    var body: some View {
        VStack{
            Text(deck.name)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
            
        }
        .frame(width: 300,height: 100)
        .background(.black)
        .cornerRadius(5)
        .frame(width: 300)
    }
}
#Preview {
    ContentView()
        .modelContainer(previewContainer)
}

