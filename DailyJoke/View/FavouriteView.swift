//
//  FavouriteView.swift
//  DailyJoke
//
//  Created by TS2 on 4/13/26.
//
import SwiftUI
import Foundation
struct FavouriteView: View {
    @State var jokes: [Joke] = []
    var body: some View {
   ScrollView{
            
     
        VStack{
            ForEach(jokes) { joke in
                FavouriteCardComp(singleJoke: joke)
            }
         
        }
        //bring data in use onAppear ask firevbase give me the favourite joke come form firebasefirestore
        //result is enum of success and failure
        .onAppear{
            FavouriteJokeFirestoreService.getJokes { result in
                switch result {
                case .success(let jokes):
                    //below line save hold favourite joke
                    self.jokes = jokes
                    
                case .failure(let error):
                    // TODO: Surface error to UI if needed
                    print("Failed to fetch favourite jokes: \(error)")
                }
            }
        }
        .padding(20)
   }//close scroll view
    
    }
}

