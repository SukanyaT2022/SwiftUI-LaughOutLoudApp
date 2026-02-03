//
//  SplashView.swift
//  DailyJoke
//
//  Created by TS2 on 2/2/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
        
        var body: some View {
            NavigationStack {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    HStack(spacing: 10) {
                        Image(systemName: "face.smiling")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                        
                        Text("DailyJoke")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .navigationDestination(isPresented: $isActive) {
                    MainTabView() // Replace with your home screen
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isActive = true
                    }
                }
            }
        }
}

#Preview {
    SplashView()
}
