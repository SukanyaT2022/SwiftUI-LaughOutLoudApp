//
//  SplashView.swift
//  DailyJoke
//
//  Created by TS2 on 2/2/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animateIn = false
        
    var body: some View {
        GeometryReader { geometry in
        
            if #available(iOS 16.0, *) {
                NavigationStack {
                    
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        VStack(alignment:.leading){
                            
                            HStack(spacing: 10) {
                                
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.yellow)
                                Text("More laugh with Daily Joke!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                
                                
                            }//hstck close
                            .background(Color.green)
                        }//close vstack
                        .background(Color.red)
                        .frame(height: 200)
                        .fixedSize(horizontal: true, vertical:false)
                        .padding(10)
                        
                        //animation move up and down
                        //start animation
                        //                .scaleEffect(animateIn ? 1 : 0.8)
                        //                .opacity(animateIn ? 1 : 0)
                        //                .animation(.interpolatingSpring(stiffness: 50, damping: 20), value: animateIn)
                    }
                    //end animation
                    
                    //row left and right
                    .offset(x:  animateIn ? 0 : -100, y: 50)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value:  animateIn)
                    
                    
                    .navigationDestination(isPresented: $isActive) {
                    BottomTabView()
                    }
                    .onAppear {
                        animateIn = true
                        //BELOW 3 SECOND OF SPLASH SCREEN
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isActive = true
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }//close gometry reeader
    }
}

#Preview {
    SplashView()
}
