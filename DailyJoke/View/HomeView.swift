//
//  HomeView.swift
//  DailyJoke
//
//  Created by TS2 on 2/2/26.
//

import SwiftUI
//below import foundationmodel to use ai offline
import FoundationModels

struct HomeView: View {
    
    let messgaeInputBox = ""
    @State private var isLoading: Bool = false
    @State private var output: String = ""
    
    var body: some View {
        VStack {
            
       
      HStack {
            Image("LaughIcon")
                .resizable()
                .frame(width: 40, height: 40)
            Text("DailyJoke")
              .fontWeight(.medium)
          
          TextField(messgaeInputBox, text: .constant("Joke"))
          // #region agent log
          
        }
        //button connect with model foundation
        Text(output)
        Button(isLoading ? "Loading..." : "Tell me a joke") {
                        generate()
                    }
                    .disabled(isLoading)
        }//close vstack
    }//close body
    
    // model foundation below
    private func generate() {
            isLoading = true
// we call foundation model by using Task-- like call api
            Task {
                do {
                    let session = LanguageModelSession()
                    let response = try await session.respond(
                        to: "Tell me 10 kid joke."
                    )
//await is for wait for the response
                    await MainActor.run {
                        output = response.content
                        isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        output = "Error: \(error.localizedDescription)"
                        isLoading = false
                    }
                }
            }
        }//close genarate func
 
}

#Preview {
    HomeView()
}
