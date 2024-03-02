import SwiftUI

struct ContentView: View {
    let fullText: String = "Questo è un esempio lungo di testo per il nostro effetto karaoke in SwiftUI. Progettato per andare a capo correttamente e mantenere l'allineamento del testo durante l'animazione."
    @State private var visibleTextLength: Int = 0
    @State private var textSpeed: Double = 0.05 // Velocità dell'animazione
    @State private var textSize: CGFloat = 24 // Dimensione del testo

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            KaraokeText(fullText: fullText, visibleTextLength: $visibleTextLength, textSize: textSize)
                .foregroundColor(.gray)
                .lineLimit(nil)
                .onAppear {
                    animateText()
                }
        }
    }

    //Animation
    private func animateText() {
        if visibleTextLength < fullText.count {
            withAnimation(.linear(duration: textSpeed)) {
                visibleTextLength += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + textSpeed) {
                animateText()
            }
        }
    }
}

//TextView
struct KaraokeText: View {
    let fullText: String
    @Binding var visibleTextLength: Int
    var textSize: CGFloat
    
    var body: some View {
        fullText.enumerated().map { index, character -> Text in
            Text(String(character))
                .font(.system(size: textSize))
                .foregroundColor(visibleTextLength > index ? .white : .gray)
        }.reduce(Text(""), +)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().background(Color.black)
    }
}
