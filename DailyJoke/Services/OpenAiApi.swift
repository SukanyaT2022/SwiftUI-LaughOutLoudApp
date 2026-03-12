//
//  OpenAiApi.swift
//  DailyJoke
//
//  Created by TS2 on 3/10/26.
//

import Foundation

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }

            let parts: [Part]
        }

        let content: Content
    }

    let candidates: [Candidate]
}

func fetchJoke(completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyC3JNB3ddepEYCoqxMwmgFoyqQjEdgBz2M")!

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
