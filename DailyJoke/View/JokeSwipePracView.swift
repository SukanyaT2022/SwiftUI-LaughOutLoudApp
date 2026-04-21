import SwiftUI
import Foundation

struct JokeSwipePracView: View {
    @StateObject private var configManager = ConfigManager()
    @State private var jokes: [Joke] = []
    @State private var jokesRequestVar: String = " "
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Jokes")
                .font(.title)

            Spacer(minLength: 0)
            
           VoiceAssistantView()
                .padding(.top, 150)
            
            CardStackView(jokes: $jokes)
                .frame(height: 460)

            Spacer(minLength: 0)
            InputCompView(text:$jokesRequestVar , placeholder: "What kind of joke do you want today?")
            Button("Tell me a joke") {
                //this ai api
                fetchJokes(jokeRequest: jokesRequestVar) { newJokes in
                    guard let newJokes else { return }
                    DispatchQueue.main.async {
                        self.jokes = newJokes
                    }
                }
            }
            .padding(.bottom, 30)
        }
        
        .onAppear {
            configManager.fetchGeminiKey()
//            fetchJokes(jokeRequest: jokesRequestVar) { newJokes in
//                guard let newJokes else { return }
//                DispatchQueue.main.async {
//                    self.jokes = newJokes
//                }
//            }
        }
    }
}

private struct CardStackView: View {
    @Binding var jokes: [Joke]

    var body: some View {
        ZStack {
            ForEach(jokes.indices.reversed(), id: \.self) { index in
                if #available(iOS 16.0, *) {
                    squareBoxShadowComp(
                        jokeQuestionVar: jokes[index].question,
                        jokeAnswerVar: jokes[index].answer,
                        onSwiped: { _ in
                            jokes.remove(at: index)
                        }
                    )
                    .scaleEffect(index == jokes.count - 1 ? 1.0 : 0.95)
                    .offset(y: index == jokes.count - 1 ? 0 : 10)  // ← back cards go DOWN, not up
                    .zIndex(Double(index))
                } else {
                    // Fallback on earlier versions
                }
            }

            if jokes.isEmpty {
                Text("No more jokes!\nTap below for more 😄")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 320, height: 400)  // ← fixed frame clips overflow
        .clipped()                        // ← this hides anything outside the frame
    }
}

private struct CardView: View {
    let question: String
    let answer: String
    let isTop: Bool
    let depth: Int
    let onSwiped: () -> Void

    var body: some View {
        let scale: CGFloat = isTop ? 1.0 : 0.95
        let yOffset: CGFloat = isTop ? 0 : CGFloat(depth) * -10

        if #available(iOS 16.0, *) {
            squareBoxShadowComp(
                jokeQuestionVar: question,
                jokeAnswerVar: answer,
                
            )
            .scaleEffect(scale)
            .offset(y: yOffset)
        } else {
            // Fallback on earlier versions
        }
    }
}
