//
//  InputCompView.swift
//  DailyJoke
//
//  Created by TS2 on 4/16/26.
//

import SwiftUI

struct InputCompView: View {
@Binding var text: String
    var placeholder: String
    var body: some View {
     
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
       
    }
}

#Preview {
    InputCompView(text: .constant(""), placeholder: "Email")
}
