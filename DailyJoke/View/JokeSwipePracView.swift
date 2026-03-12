//
//  JokeSwipePracView.swift
//  DailyJoke
//
//  Created by TS2 on 3/9/26.
//

import SwiftUI

struct JokeSwipePracView: View {
    @State private var jokeText: String = "Loading joke..."
    var body: some View {
   VStack {
            Text("Hello, World!")
      Text(jokeText)
       //button from opai ai
       
       Button("Tell me a joke") {
           fetchJoke { joke in
               DispatchQueue.main.async {
                   self.jokeText = joke ?? "No joke today!"
               }
           }
       }
        }
    }
}

#Preview {
    JokeSwipePracView()
}
