import SwiftUI
import Combine

// MARK: - Model
struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: Content
    }
    
    struct Content: Codable {
        let parts: [Part]
    }
    
    struct Part: Codable {
        let text: String
    }
}

// MARK: - Service
class GeminiService {
    private let apiKey = "AIzaSyAjBA1MP067NgY9uGYi267G0XPKj1XvM70" // 🔑 Replace with your new key
    private let model = "gemini-2.0-flash"
    
    func generateContent(prompt: String) async throws -> String {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return response.candidates.first?.content.parts.first?.text ?? "No response"
    }
}

// MARK: - ViewModel
@MainActor
class GeminiViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var response = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let service = GeminiService()
    
    func sendMessage() async {
        guard !prompt.isEmpty else { return }
        isLoading = true
        errorMessage = ""
        response = ""
        
        do {
            response = try await service.generateContent(prompt: prompt)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = GeminiViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                // Response Area
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Thinking...")
                            .padding()
                    } else if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text(viewModel.response.isEmpty ? "Ask me anything..." : viewModel.response)
                            .foregroundColor(viewModel.response.isEmpty ? .gray : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Input Area
                HStack {
                    TextField("Enter your prompt...", text: $viewModel.prompt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        Task {
                            await viewModel.sendMessage()
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.isLoading || viewModel.prompt.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Gemini AI")
        }
    }
}

func fetchJoke(completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyBElmTCcau4c335JRAI1bjk15AYaF4XP3Y")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "contents": [
            [
                "parts": [
                    [
                        "text": "Tell me 5 programmer jokes. Put each joke on a new line."
                    ]
                ]
            ]
        ]
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        let decoded = try? JSONDecoder().decode(GeminiResponse.self, from: data)
        let joke = decoded?.candidates.first?.content.parts.first?.text
        completion(joke)
    }.resume()
}


#Preview {
    ContentView()
}
