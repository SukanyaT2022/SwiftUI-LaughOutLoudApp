import SwiftUI
import Foundation

@available(iOS 16.0, *)
struct squareBoxShadowComp: View {
    @State private var isFlipped = false
    @State private var offset: CGSize = .zero
    let jokeQuestionVar: String
    let jokeAnswerVar: String
    var onSwiped: ((Bool) -> Void)? = nil  // true = liked, false = noped

    
    @available(iOS 16.0, *)
    var body: some View {
        ZStack {
            // FRONT
            VStack(spacing: 20) {
                if #available(iOS 16.0, *) {
                    Image(systemName: "questionmark")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                } else {
                    // Fallback on earlier versions
                };if #available(iOS 16.0, *) {
                    Image(systemName: "questionmark")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                } else {
                    // Fallback on earlier versions
                };if #available(iOS 16.0, *) {
                    Image(systemName: "questionmark")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                } else {
                    // Fallback on earlier versions
                };if #available(iOS 16.0, *) {
                    Image(systemName: "questionmark")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                } else {
                    // Fallback on earlier versions
                }

                Text(jokeQuestionVar)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .opacity(isFlipped ? 0 : 1)

            // BACK
            VStack {
                Text("\(jokeAnswerVar) 🦆😂")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

            // LIKE / NOPE labels
            HStack {
                Text("NOPE")
                    .font(.title).bold()
                    .foregroundColor(.red)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.red, lineWidth: 3))
                    .opacity(Double(-offset.width / 80).clamped(to: 0...1))
                Spacer()
                Text("LIKE")
                    .font(.title).bold()
                    .foregroundColor(.green)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 3))
                    .opacity(Double(offset.width / 80).clamped(to: 0...1))
            }
            .padding(.horizontal, 20)
        }
        .padding(20)
        // BEFORE
//        .frame(width: 320, height: 420)

        // AFTER
        .frame(width: 300, height: 380)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        // NO .shadow() here
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .offset(x: offset.width, y: offset.height * 0.3)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        handleSwipe(width: gesture.translation.width)
                    }
                }
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }

    func handleSwipe(width: CGFloat) {
        switch width {
        case let w where w < -150:
            offset = CGSize(width: -600, height: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped?(false) // NOPE
            }
        case let w where w > 150:
            offset = CGSize(width: 600, height: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped?(true) // LIKE
            }
        default:
            offset = .zero // snap back
        }
    }
}

// Helper to clamp opacity
extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
