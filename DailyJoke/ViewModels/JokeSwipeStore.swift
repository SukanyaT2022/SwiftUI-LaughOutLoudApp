import Foundation
import Combine
@MainActor
final class JokeSwipeStore: ObservableObject {
    @Published var jokes: [Joke] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    func loadJokes(fromVoiceText voiceText: String) async {
        let cleaned = voiceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }

        isLoading = true
        errorMessage = ""

        let prompt = """
        The user said: "\(cleaned)"

        Create 10 jokes that match the request.
        Return ONLY a JSON array of objects with keys: question, answer.
        Keep the jokes safe and family-friendly.
        """

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            fetchJokes(jokeRequest: prompt) { [weak self] jokes in
                DispatchQueue.main.async {
                    guard let self else {
                        continuation.resume()
                        return
                    }

                    if let jokes, !jokes.isEmpty {
                        self.jokes = jokes
                    } else {
                        self.jokes = []
                        self.errorMessage = "Gemini returned no jokes. Try again."
                    }

                    self.isLoading = false
                    continuation.resume()
                }
            }
        }
    }

    func reset() {
        jokes = []
        isLoading = false
        errorMessage = ""
    }
}

