//
//  FavouriteCardComp.swift
//  DailyJoke
//
//  Created by TS2 on 5/7/26.
//

import SwiftUI

struct FavouriteCardComp: View {
    var body: some View {
        VStack(){
        HStack{
            Image("cat")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 4)))
                .shadow(radius: 10)
                .padding(.trailing,5)
            VStack{
                Text("Question")
                Text("Answer")
            }
            Spacer()
        }//close hstack on top
       
//            Spacer()
            HStack(spacing:10){
                ButtonComp(title: "Share", systemImage: "point.3.connected.trianglepath.dotted") {
                    print("Share tapped!")
                }
          
                
                ButtonComp(title: "open", systemImage:"square.and.arrow.up") {
                    print("Share tapped!")
                }
         
                ButtonComp(title: "Like", systemImage:"heart.fill") {
                    print("Share tapped!")
                }
                
           
            }//close below hstack
            .frame(width:UIScreen.main.bounds.width-60)
            
        }//close v stack
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
       
     
        
        
    }
}
#Preview {
    FavouriteCardComp()
}

