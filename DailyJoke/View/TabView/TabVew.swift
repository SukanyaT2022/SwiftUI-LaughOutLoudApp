//
//  TabVew.swift
//  DailyJoke
//
//  Created by TS2 on 4/13/26.
//
import SwiftUI
import Foundation

struct BottomTabView: View {
    var body: some View {
        TabView {
            JokeSwipeView()
                .tabItem {
                    Image(systemName: "house")
                
                }

            JokeSwipeView()
                .tabItem {
                    Image(systemName: "list.bullet")
                 
                }

            FavouriteView()
                .tabItem {
                    Image(systemName: "heart")
                  
                }

            ShareView()
                .tabItem {
                    Image(systemName: "message.fill")
                
                }
            LoginView()
                .tabItem {
                    Image(systemName: "person.fill")
                
                }
        }
    }
}
