//
//  HomeView.swift
//  DailyJoke
//
//  Created by TS2 on 2/2/26.
//

import SwiftUI

struct HomeView: View {
    let messgaeInputBox = ""
    var body: some View {
      HStack {
            Image("LaughIcon")
                .resizable()
                .frame(width: 40, height: 40)
            Text("DailyJoke")
              .fontWeight(.medium)
          
          TextField(messgaeInputBox, text: .constant("Joke"))
          // #region agent log
          
        }
      
    }
}

#Preview {
    HomeView()
}
