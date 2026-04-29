//
//  JokeSwipeView.swift
//  DailyJoke
//
//  Created by TS2 on 3/4/26.
//

import SwiftData
import SwiftUI

// MARK: - Swipe Direction

enum SwipeDirection {
    case left, right, up, none
}

// MARK: - Comparable Clamp Helper

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Joke Card View

struct JokeCardView: View {
    let joke: Joke
    @Binding var swipeOffset: CGSize
    @Binding var swipeOverlay: SwipeDirection
    @State private var isFlipped: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "FFD59E"), Color(hex: "E75480")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            ZStack {
                // FRONT (Question)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Q")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.18))
                        .clipShape(Capsule())

                    Text(joke.question)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    HStack(spacing: 10) {
                        Text("A")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.18))
                            .clipShape(Capsule())

                        Text("Tap to flip")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.14))
                        .frame(height: 68)
                        .overlay(
                            Text("••••••••••")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.35))
                        )
                }
                .padding(24)
                .opacity(isFlipped ? 0 : 1)

                // BACK (Answer)
                VStack(alignment: .leading, spacing: 14) {
                    Text("A")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.18))
                        .clipShape(Capsule())

                    Text(joke.answer)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    HStack(spacing: 10) {
                        Text("Q")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.18))
                            .clipShape(Capsule())

                        Text("Tap to flip back")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.14))
                        .frame(height: 68)
                        .overlay(
                            Text("Keep swiping")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
                .padding(24)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }

            // Swipe overlay
            Group {
                switch swipeOverlay {
                case .right:
                    Text("FUNNY")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.green)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 3))
                        .rotationEffect(.degrees(-14))
                        .padding(18)
                case .left:
                    Text("SKIP")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.red)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3))
                        .rotationEffect(.degrees(14))
                        .padding(18)
                case .up:
                    Text("HILARIOUS")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 3))
                        .rotationEffect(.degrees(-6))
                        .padding(18)
                case .none:
                    EmptyView()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.65)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .offset(swipeOffset)
        .scaleEffect(1 - min(abs(swipeOffset.width) / 1800, 0.03))
        .shadow(color: .black.opacity(0.35), radius: 24, x: 0, y: 14)
        .onTapGesture {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                isFlipped.toggle()
            }
        }
    }
}

// MARK: - Main Swipe View

struct JokeSwipeView: View {
    @State private var jokes: [Joke] = []
    @State private var swipeOffset: CGSize = .zero
    @State private var swipeOverlay: SwipeDirection = .none
    @State private var funnyCount: Int = 0
    @State private var skipCount: Int = 0
    @State private var hilariousCount: Int = 0
    @State private var lastAction: String = ""

    init(jokes initialJokes: [Joke] = []) {
        _jokes = State(initialValue: initialJokes)
    }

    var body: some View {
        ZStack {
            // Background
            Color(hex: "1A1A2E")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("JokeSwipe")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Swipe right if funny 😂")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    HStack(spacing: 14) {
                        StatBadge(emoji: "😂", count: funnyCount, color: .green)
                        StatBadge(emoji: "🤣", count: hilariousCount, color: .blue)
                        StatBadge(emoji: "😐", count: skipCount, color: .red)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Cards stack
                ZStack {
                    if jokes.isEmpty {
                        VStack(spacing: 20) {
                            Text("🎭")
                                .font(.system(size: 80))
                            Text("You've seen all jokes!")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    } else {
                        // Background cards (stack effect)
                        ForEach(Array(jokes.prefix(3).enumerated().reversed()), id: \.element.id) { index, _ in
                            if index > 0 {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(
                                        width: UIScreen.main.bounds.width - 40 - CGFloat(index * 16),
                                        height: UIScreen.main.bounds.height * 0.65 - CGFloat(index * 16)
                                    )
                                    .offset(y: CGFloat(index * 10))
                                    .opacity(0.6)
                            }
                        }

                        // Top card (interactive)
                        if let topJoke = jokes.first {
                            JokeCardView(
                                joke: topJoke,
                                swipeOffset: $swipeOffset,
                                swipeOverlay: $swipeOverlay
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        swipeOffset = value.translation
                                        if value.translation.width > 40 {
                                            swipeOverlay = .right
                                        } else if value.translation.width < -40 {
                                            swipeOverlay = .left
                                        } else if value.translation.height < -40 {
                                            swipeOverlay = .up
                                        } else {
                                            swipeOverlay = .none
                                        }
                                    }
                                    .onEnded { value in
                                        handleSwipeEnd(translation: value.translation)
                                    }
                            )
                            .animation(.interactiveSpring(), value: swipeOffset)
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                // Last action feedback
                if !lastAction.isEmpty {
                    Text(lastAction)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.vertical, 6)
                        .transition(.opacity)
                }

                // Action Buttons
                HStack(spacing: 20) {
                    ActionButton(emoji: "😐", color: Color(hex: "E74C3C"), size: 56) {
                        triggerSwipe(direction: .left)
                    }
                    ActionButton(emoji: "🤣", color: Color(hex: "3498DB"), size: 48) {
                        triggerSwipe(direction: .up)
                    }
                    ActionButton(emoji: "😂", color: Color(hex: "2ECC71"), size: 56) {
                        triggerSwipe(direction: .right)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            }
        }
    }

    // MARK: - Swipe Logic

    func handleSwipeEnd(translation: CGSize) {
        let threshold: CGFloat = 100
        if translation.width > threshold {
            dismissCard(direction: .right)
        } else if translation.width < -threshold {
            dismissCard(direction: .left)
        } else if translation.height < -threshold {
            dismissCard(direction: .up)
        } else {
            // Snap back — no rotation to reset
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                swipeOffset = .zero
                swipeOverlay = .none
            }
        }
    }

    func triggerSwipe(direction: SwipeDirection) {
        swipeOverlay = direction
        let offset: CGSize
        switch direction {
        case .right:
            offset = CGSize(width: 600, height: 0)
        case .left:  offset = CGSize(width: -600, height: 0)
        case .up:    offset = CGSize(width: 0, height: -600)
        case .none:  offset = .zero
        }
        withAnimation(.easeOut(duration: 0.35)) {
            swipeOffset = offset
            // ✅ No rotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            removeTopCard(direction: direction)
        }
    }

    func dismissCard(direction: SwipeDirection) {
        let offset: CGSize
        switch direction {
        case .right: offset = CGSize(width: 600, height: 0)
        case .left:  offset = CGSize(width: -600, height: 0)
        case .up:    offset = CGSize(width: 0, height: -600)
        case .none:  offset = .zero
        }
        withAnimation(.easeOut(duration: 0.3)) {
            swipeOffset = offset
            // ✅ No rotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            removeTopCard(direction: direction)
        }
    }

    func removeTopCard(direction: SwipeDirection) {
        guard !jokes.isEmpty else { return }
        jokes.removeFirst()
        withAnimation(.spring()) {
            swipeOffset = .zero
            swipeOverlay = .none
        }
        switch direction {
        case .right:
            funnyCount += 1
            lastAction = "😂 Funny!"
        case .left:
            skipCount += 1
            lastAction = "😐 Skipped"
        case .up:
            hilariousCount += 1
            lastAction = "🤣 Hilarious!"
        case .none:
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { lastAction = "" }
        }
    }
}

// MARK: - Supporting Views

struct StatBadge: View {
    let emoji: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(emoji).font(.system(size: 18))
            Text("\(count)")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
    }
}

struct ActionButton: View {
    let emoji: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: size * 0.45))
                .frame(width: size, height: size)
                .background(color.opacity(0.15))
                .overlay(
                    Circle().stroke(color.opacity(0.4), lineWidth: 2)
                )
                .clipShape(Circle())
        }
    }
}

// MARK: - Preview

#Preview {
    JokeSwipeView(jokes: [
        Joke(question: "Why did the chicken cross the road?", answer: "To get to the other side."),
        Joke(question: "What do you call fake spaghetti?", answer: "An impasta!")
    ])
}
