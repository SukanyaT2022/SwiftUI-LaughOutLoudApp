//
//  FavouriteCardComp.swift
//  DailyJoke
//
//  Created by TS2 on 5/7/26.
//

import SwiftUI

struct FavouriteCardComp: View {
    let singleJoke: Joke
    
    //line below update closure function with no name - this help to us to give call back to back of screen
    //screen when detete favourite
    let updateChangeVar : (Joke) -> Void
    
   let shareURL = URL(string: "https://www.koonmow.com/")!
    
 
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
          
                 Image(systemName: "xmark.circle.fill")
                     .font(.system(size: 20, weight: .semibold))
                     .foregroundStyle(.secondary)
                     .padding(8)
                     .offset(x:30, y:-22)
//            ontap when user tap something happen
                     .onTapGesture {
                         //delete for me
                         FavouriteJokeFirestoreService.deleteJoke(singleJoke)  { result in
                             switch result {
                             case .success:
                                 print("Delete Joke Successfully")
                                 
                                 //update for me screen when detete favourite--below
                             updateChangeVar(singleJoke)
                                 
                             case .failure(let error):
                                 // TODO: Surface error to UI if needed
                                 print("Failed to fetch favourite jokes: \(error)")
                             }
                         }
                     }
         
             .padding(8)
            
            // Card content
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image("cat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 4)))
                        .shadow(radius: 10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(singleJoke.question)
                            .font(.headline)
                        Text(singleJoke.answer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 10) {
                   
                    ShareLink(
                        item: shareURL,
                        subject: Text(singleJoke.question),
                        message: Text("\(singleJoke.question)\n\(singleJoke.answer)")
                    ) {
                        DummyButtonComp(
                            title: "Share",
                            systemImage: "square.and.arrow.up"
                        )
                    }
               
            
                ButtonComp(title: "Like", systemImage: "heart.fill") {
                    print("Like tapped!")
                }
                }
            
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
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

            // Close button overlay pinned to top-right of the card
          
        }
    }
//
//#Preview {
//    FavouriteCardComp(singleJoke: Joke(question: "Why did the chicken cross the road?", answer: "To get to the other side.")
//     
//
//}

