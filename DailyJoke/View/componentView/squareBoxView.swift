//
//  squareBoxView.swift
//  DailyJoke
//
//  Created by TS2 on 3/9/26.
//

import SwiftUI

struct squareBoxView: View {
    var imageVar : String = "cat.png"
    var questionVar : String = "Oopsie! no question!"
    var buttonVar: String = "Try again"
    var buttonActionVar: () -> Void
    
    var body: some View {
        VStack(){
            Image(imageVar)
                .resizable()
                .frame(width: 70, height: 70)
            Text(questionVar)
            
            Button(buttonVar){
               buttonActionVar()
            }
          
            .background(Color.red)
          
        }
        .padding(20)
                .frame(width: 250, height: 250)
                .background(Color.green)
                .cornerRadius(50)
               
            }
            
        }

#Preview {
    squareBoxView(
        imageVar : "cat",
     questionVar : "chicken walk onn the lane",
     buttonVar:"click here",
        buttonActionVar:{}
            
   )
    
}
