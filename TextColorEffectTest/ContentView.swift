import SwiftUI

struct ContentView: View {
    let fullText: String = "Questo è un esempio lungo di testo per il nostro effetto karaoke in SwiftUI. Progettato per andare a capo correttamente e mantenere l'allineamento del testo durante l'animazione."
    @State private var visibleTextLength: Int = 0
    @State private var textSpeed: Double = 0.2 // Velocità dell'animazione
    @State private var textSize: CGFloat = 24 // Dimensione del testo

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            KaraokeText(fullText: fullText, visibleWordsCount: $visibleTextLength, textSize: textSize)
                .foregroundColor(.gray)
                .lineLimit(nil)
                .onAppear {
                    animateText()
                }
        }
    }


    private func animateText() {
        let words = fullText.split { $0.isWhitespace }.map(String.init)
        if visibleTextLength < words.count {
            withAnimation(.linear(duration: textSpeed)) {
                visibleTextLength += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + textSpeed) {
                animateText()
            }
        }
    }
}

//Text
struct KaraokeText: View {
    let fullText: String
    @Binding var visibleWordsCount: Int
    var textSize: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) { // Allineamento aggiunto qui
            // Testo completo di sfondo in grigio
            Text(fullText)
                .font(.system(size: textSize))
                .foregroundColor(.gray)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading) // Assicurati che sia allineato a sinistra

            // Testo animato che mostra solo le parole visibili
            Text(visibleText)
                .font(.system(size: textSize))
                .foregroundColor(.white)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading) // Assicurati che sia allineato a sinistra
        }
        // Potresti dover aggiungere un .frame qui se vuoi che ZStack occupi più spazio
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var visibleText: String {
        let words = fullText.split(separator: " ", maxSplits: Int.max, omittingEmptySubsequences: true).map(String.init)
        let visibleWords = words.prefix(visibleWordsCount)
        return visibleWords.joined(separator: " ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().background(Color.black)
    }
}
