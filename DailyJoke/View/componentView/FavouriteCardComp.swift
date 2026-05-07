//
//  FavouriteCardComp.swift
//  DailyJoke
//
//  Created by TS2 on 5/7/26.
//

import SwiftUI

struct FavouriteCardComp: View {
    var body: some View {
        HStack{
            Image("cat")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 4)))
                .shadow(radius: 10)
            VStack{
                Text("Question")
                Text("Answer")
            }
            HStack{
                ButtonComp(title: "Share", systemImage: "sharelink") {
                    print("Share tapped!")
                }
            }
        }
    }
}
//#Preview {
//    FavouriteCardComp()
//}
