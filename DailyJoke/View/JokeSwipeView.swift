//
//  JokeSwipeView.swift
//  DailyJoke
//
//  Created by TS2 on 3/4/26.
//


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
    @State private var revealed: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Gradient
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: joke.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.18), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )

            // Card Content
            VStack(spacing: 0) {
                // Top: category badge
                HStack {
                    Label(joke.category, systemImage: "face.smiling.fill")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(.white.opacity(0.25))
                        .clipShape(Capsule())
                    Spacer()
                    Text(joke.categoryEmoji)
                        .font(.system(size: 32))
                }
                .padding(.horizontal, 22)
                .padding(.top, 28)

                Spacer()

                // Joke Emoji
                Text("🎭")
                    .font(.system(size: 72))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                Spacer()

                // Setup text
                Text(joke.setup)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 16)

                // Reveal punchline button / punchline
                if revealed {
                    Text(joke.punchline)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(.black.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 22)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                            revealed = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                            Text("Reveal Punchline")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(joke.gradient.last ?? .white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(.white)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                    }
                    .transition(.opacity)
                }

                Spacer(minLength: 20)

                // Bottom info
                VStack(alignment: .leading, spacing: 10) {
                    Divider().overlay(Color.white.opacity(0.3))

                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(joke.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }

            // 😂 FUNNY overlay (swipe right)
            if swipeOverlay == .right {
                VStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 4)
                            Text("😂 FUNNY")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundColor(.green)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                        }
                        .padding(.leading, 24)
                        .opacity(Double(swipeOffset.width / 80).clamped(to: 0...1))
                        Spacer()
                    }
                    .padding(.top, 50)
                    Spacer()
                }
            }

            // 😐 SKIP overlay (swipe left)
            if swipeOverlay == .left {
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 4)
                            Text("😐 SKIP")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundColor(.red)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                        }
                        .padding(.trailing, 24)
                        .opacity(Double((-swipeOffset.width) / 80).clamped(to: 0...1))
                    }
                    .padding(.top, 50)
                    Spacer()
                }
            }

            // 🤣 HILARIOUS overlay (swipe up)
            if swipeOverlay == .up {
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4)
                        Text("🤣 HILARIOUS")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                    }
                    .opacity(Double((-swipeOffset.height) / 80).clamped(to: 0...1))
                    .padding(.bottom, 190)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.65)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.2), radius: 22, x: 0, y: 12)
        .offset(swipeOffset)
        // ✅ No rotationEffect — card slides straight
        .onChange(of: swipeOffset) { _ in
            if abs(swipeOffset.width) > 30 || swipeOffset.height < -30 {
                revealed = false
            }
        }
    }
}

// MARK: - Main Swipe View

struct JokeSwipeView: View {
    @State private var jokeViewModel = JokeDataViewModel()
    @State private var jokes: [Joke] = []
    @State private var swipeOffset: CGSize = .zero
    @State private var swipeOverlay: SwipeDirection = .none
    @State private var funnyCount: Int = 0
    @State private var skipCount: Int = 0
    @State private var hilariousCount: Int = 0
    @State private var lastAction: String = ""

    init() {
        _jokes = State(initialValue: JokeDataViewModel().sampleJokes)
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
                            Button {
                                withAnimation {
                                    jokes = jokeViewModel.sampleJokes.shuffled()
                                    funnyCount = 0
                                    skipCount = 0
                                    hilariousCount = 0
                                    lastAction = ""
                                }
                            } label: {
                                Text("Shuffle & Restart 🔀")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 14)
                                    .background(Color(hex: "E75480"))
                                    .clipShape(Capsule())
                            }
                        }
                    } else {
                        // Background cards (stack effect)
                        ForEach(Array(jokes.prefix(3).enumerated().reversed()), id: \.element.id) { index, joke in
                            if index > 0 {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(
                                        LinearGradient(
                                            colors: joke.gradient,
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
                                        // ✅ No rotation assigned
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
        case .right: offset = CGSize(width: 600, height: 0)
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
    JokeSwipeView()
}
