import SwiftUI
import Combine

/// Single source for the working Postman/cURL setup (`…/models/{model}:generateContent`).
private enum GeminiREST {
    static let model = "gemini-flash-latest"
    static let apiKey = "AIzaSyAHAy3d_bzMHkpeDyOM_ncB3G59Cxyrq0Q"
}

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
    func generateContent(prompt: String) async throws -> String {
        let urlString = "\(AppConfig.apiBaseURL)/v1beta/models/\(GeminiREST.model):generateContent"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GeminiREST.apiKey, forHTTPHeaderField: "x-goog-api-key")
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            let bodyText = String(data: data, encoding: .utf8) ?? ""
            throw NSError(
                domain: "Gemini",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(bodyText)"]
            )
        }
        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return decoded.candidates.first?.content.parts.first?.text ?? "No response"
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

// AppConfig.apiBaseURL must be a full hostname like "https://generativelanguage.googleapis.com"
func fetchJoke(completion: @escaping (String?) -> Void) {
    let path = "/v1beta/models/\(GeminiREST.model):generateContent"
    guard let url = URL(string: AppConfig.apiBaseURL + path) else { completion(nil); return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(GeminiREST.apiKey, forHTTPHeaderField: "x-goog-api-key")

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
        if let error {
            #if DEBUG
            print("fetchJoke:", error.localizedDescription)
            #endif
            completion(nil)
            return
        }
        guard let data, let http = response as? HTTPURLResponse else {
            completion(nil)
            return
        }
        guard (200...299).contains(http.statusCode) else {
            #if DEBUG
            print("fetchJoke HTTP \(http.statusCode):", String(data: data, encoding: .utf8) ?? "")
            #endif
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
