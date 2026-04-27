//
//  VoiceAssistantView.swift
//  DailyJoke
//
//  Created by TS2 on 4/21/26.
//
import SwiftUI
import AVFoundation
import Speech


// MARK: - Orb Animation View
struct GlowingOrbView: View {
    @Binding var isAnimating: Bool
    @Binding var isListening: Bool

    @State private var rotation1: Double = 0
    @State private var rotation2: Double = 120
    @State private var rotation3: Double = 240
    @State private var scale: CGFloat = 1.0
    @State private var pulseScale: CGFloat = 1.0

    let orbSize: CGFloat = 180

    var body: some View {
        ZStack {
            // Outer pulse glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.orange.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: orbSize
                    )
                )
                .frame(width: orbSize * 1.8, height: orbSize * 1.8)
                .scaleEffect(pulseScale)
                .animation(
                    isListening
                        ? Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)
                        : .default,
                    value: pulseScale
                )

            // Ring 1
            OrbRing(color: Color(red: 1.0, green: 0.0, blue: 0.4), lineWidth: 2.5)
                .frame(width: orbSize, height: orbSize)
                .rotationEffect(.degrees(rotation1))
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0.3, z: 0))

            // Ring 2
            OrbRing(color: Color(red: 0.0, green: 0.85, blue: 0.3), lineWidth: 2.0)
                .frame(width: orbSize * 0.85, height: orbSize * 0.85)
                .rotationEffect(.degrees(rotation2))
                .rotation3DEffect(.degrees(50), axis: (x: 0.5, y: 1, z: 0.2))

            // Ring 3
            OrbRing(color: Color(red: 0.4, green: 1.0, blue: 0.6), lineWidth: 1.5)
                .frame(width: orbSize * 0.7, height: orbSize * 0.7)
                .rotationEffect(.degrees(rotation3))
                .rotation3DEffect(.degrees(70), axis: (x: 0.2, y: 0.5, z: 1))

            // Center bright core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 24
                    )
                )
                .frame(width: 48, height: 48)
                .blur(radius: 4)
        }
        .scaleEffect(scale)
        .onAppear {
            startAnimations()
        }
        .onChange(of: isListening) { listening in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = listening ? 1.15 : 1.0
            }
            pulseScale = listening ? 1.25 : 1.0
        }
    }

    private func startAnimations() {
        let speed: Double = isListening ? 0.8 : 1.8

        withAnimation(
            Animation.linear(duration: speed * 2.2).repeatForever(autoreverses: false)
        ) {
            rotation1 = 360
        }
        withAnimation(
            Animation.linear(duration: speed * 3.0).repeatForever(autoreverses: false)
        ) {
            rotation2 = 360 + 120
        }
        withAnimation(
            Animation.linear(duration: speed * 2.6).repeatForever(autoreverses: false)
        ) {
            rotation3 = 360 + 240
        }
    }
}

// MARK: - Orb Ring Shape
struct OrbRing: View {
    let color: Color
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            // Main ring arc
            Circle()
                .trim(from: 0.05, to: 0.85)
                .stroke(
                    LinearGradient(
                        colors: [color.opacity(0.1), color, color.opacity(0.9), color.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .shadow(color: color.opacity(0.8), radius: 6, x: 0, y: 0)
                .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 0)

            // Bright highlight arc
            Circle()
                .trim(from: 0.6, to: 0.75)
                .stroke(
                    color.opacity(0.95),
                    style: StrokeStyle(lineWidth: lineWidth * 1.5, lineCap: .round)
                )
                .shadow(color: color, radius: 8)
        }
    }
}

// MARK: - Typewriter Subtitle
struct TypewriterText: View {
    let phrases: [String]
    @State private var displayedText: String = ""
    @State private var phraseIndex: Int = 0
    @State private var charIndex: Int = 0
    @State private var isDeleting: Bool = false
    @State private var timer: Timer?

    var body: some View {
        HStack(spacing: 2) {
            Text(displayedText)
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .foregroundColor(.white.opacity(0.55))
            // blinking cursor
            Rectangle()
                .frame(width: 2, height: 14)
                .foregroundColor(.white.opacity(0.55))
                .opacity(displayedText.isEmpty ? 0 : 1)
        }
        .onAppear { startTyping() }
        .onDisappear { timer?.invalidate() }
    }

    private func startTyping() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { _ in
            let phrase = phrases[phraseIndex]

            if !isDeleting {
                if charIndex < phrase.count {
                    let idx = phrase.index(phrase.startIndex, offsetBy: charIndex)
                    displayedText = String(phrase[...idx])
                    charIndex += 1
                } else {
                    // pause then delete
                    timer?.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isDeleting = true
                        startTyping()
                    }
                }
            } else {
                if !displayedText.isEmpty {
                    displayedText = String(displayedText.dropLast())
                } else {
                    isDeleting = false
                    charIndex = 0
                    phraseIndex = (phraseIndex + 1) % phrases.count
                }
            }
        }
    }
}

// MARK: - Text Input Bar
struct TextInputBar: View {
    @Binding var text: String
    @Binding var isShowingKeyboard: Bool
    var onSend: (String) -> Void

    private func sendText() {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onSend(trimmed)
        text = ""
    }
    
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Type something funny...", text: $text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .tint(Color(red: 0.2, green: 1.0, blue: 0.4))
                .submitLabel(.send)
                .onSubmit { sendText() }

            if !text.isEmpty {
                Button(action: sendText){
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color(red: 0.2, green: 1.0, blue: 0.4))
                        .shadow(color: Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.7), radius: 6)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.5),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .animation(.spring(response: 0.3), value: text.isEmpty)
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBar: View {
    @Binding var isListening: Bool
    @Binding var isShowingKeyboard: Bool
    @ObservedObject var speechRecognizer: SpeechRecognizer
    var body: some View {
        HStack {
            // Contacts
            Button(action: {}) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            // Voice orb button
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    if speechRecognizer.isRecording {
                        speechRecognizer.stopListening()
                        isListening = false
                    } else {
                        speechRecognizer.startListening()
                        isListening = true
                        isShowingKeyboard = false
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            isListening
                                ? Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.18)
                                : Color.white.opacity(0.08)
                        )
                        .frame(width: 52, height: 52)
                        .overlay(
                            Circle()
                                .stroke(
                                    isListening
                                        ? Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.6)
                                        : Color.white.opacity(0.2),
                                    lineWidth: 1.5
                                )
                        )

                    Image(systemName: isListening ? "waveform" : "mic")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            isListening
                                ? Color(red: 0.2, green: 1.0, blue: 0.4)
                                : .white.opacity(0.8)
                        )
                }
            }
            .shadow(
                color: isListening
                    ? Color(red: 0.2, green: 1.0, blue: 0.4).opacity(0.5)
                    : .clear,
                radius: 12
            )

            Spacer()

            // Keyboard toggle
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    if speechRecognizer.isRecording {
                        speechRecognizer.stopListening()
                        isListening = false
                    } else {
                        speechRecognizer.startListening()
                        isListening = true
                        isShowingKeyboard = false
                    }
                }
            } label: {
                Image(systemName: "keyboard")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }

        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
}

// MARK: - Main View
struct VoiceAssistantView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()  // ← ADD
    @StateObject private var transcriptStore  = TranscriptStore()   // ← ADD
    @StateObject private var jokeSwipeStore = JokeSwipeStore()
    @State private var showTranscript: Bool   = false
    @State private var showJokeSwipe: Bool = false
    @State private var isListening: Bool = false
    @State private var isShowingKeyboard: Bool = false
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool
    

    private let subtitlePhrases = [
        "I can tell you a joke",
        "Ask me anything funny",
        "I know 1000 puns",
        "Humor is my superpower",
        "Let's have a laugh"
    ]

    var body: some View {
        ZStack {
            // Background
            backgroundLayer

            VStack(spacing: 0) {
                // Top bar with transcript counter
                HStack {
                    Spacer()
                    Button { showTranscript = true } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "text.quote").font(.system(size: 14))
                            Text("\(transcriptStore.entries.count)").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.55))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.white.opacity(0.08)))
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 60)

                // Subtitle typewriter
                TypewriterText(phrases: subtitlePhrases)
                    
                // Main title
                Text("How Can I Make\nYou Laugh Today?")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .shadow(color: .white.opacity(0.15), radius: 20)
                    .padding(.horizontal, 32)

                Spacer()

                if let error = speechRecognizer.errorMessage, !error.isEmpty {
                    Text(error)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.red.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.25), lineWidth: 1)
                                )
                        )
                        .padding(.bottom, 8)
                }

                
                // Live voice text — appears as user speaks
                if isListening && !speechRecognizer.transcribedText.isEmpty {
                    Text(speechRecognizer.transcribedText)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.orange.opacity(0.12))
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1))
                        )
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                }

                
                
                // Orb
                GlowingOrbView(isAnimating: .constant(true), isListening: $isListening)
                    .frame(width: 340, height: 340)

                Spacer()

                // Keyboard toggle hint
                if !isShowingKeyboard && !isListening {
                    Button(action: {
                        withAnimation(.spring()) {
                            isShowingKeyboard = true
                            isInputFocused = true
                        }
                    }) {
                        Label("Use Keyboard", systemImage: "keyboard")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .transition(.opacity)
                    .padding(.bottom, 16)
                }

                // Text input
                if isShowingKeyboard {
                    TextInputBar(
                        text: $inputText,
                        isShowingKeyboard: $isShowingKeyboard
                    ) { typedText in
                        transcriptStore.add(text: typedText, source: .keyboard)  // saves to .txt
                    }
                    
                    
                    
                    
                    .focused($isInputFocused)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear { isInputFocused = true }
                }

                // Bottom bar
                BottomTabBar(
                    isListening: $isListening,
                    isShowingKeyboard: $isShowingKeyboard,
                    speechRecognizer: speechRecognizer   // ← ADD
                )
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        
        .onAppear {
            // Ask for mic + speech permission when screen loads
            speechRecognizer.requestPermissions { _ in }
        }
        .onChange(of: speechRecognizer.isRecording) { recording in
            // When user stops speaking → save to transcript file
            isListening = recording
           
        
            if speechRecognizer.transcribedText.count > 500 { return }
            if !recording && !speechRecognizer.transcribedText.isEmpty {
                transcriptStore.add(
                    text: speechRecognizer.transcribedText,
                    source: .voice
                )

                let voiceText = speechRecognizer.transcribedText
                Task {
                    await jokeSwipeStore.loadJokes(fromVoiceText: voiceText)
                    if !jokeSwipeStore.jokes.isEmpty {
                        showJokeSwipe = true
                    }
                }
            }
            print("$test: \(speechRecognizer.transcribedText)")
        }
        .sheet(isPresented: $showTranscript) {
            // Opens the history log sheet
            TranscriptLogView(store: transcriptStore)
                .frame(width: 400, height: 200)
        }
        .fullScreenCover(isPresented: $showJokeSwipe) {
            ZStack {
                JokeSwipeView(jokes: jokeSwipeStore.jokes)
                    .ignoresSafeArea()

                if jokeSwipeStore.isLoading {
                    ProgressView("Loading jokes…")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else if !jokeSwipeStore.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Text(jokeSwipeStore.errorMessage)
                            .font(.system(size: 14, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)

                        Button("Close") { showJokeSwipe = false }
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Capsule())
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                }
            }
        }
    }

    // MARK: Background
    @ViewBuilder
    private var backgroundLayer: some View {
        ZStack {
            // Base dark green-black
            Color(red: 0.04, green: 0.10, blue: 0.06)
                .ignoresSafeArea()

            // Radial glow from orb area
            RadialGradient(
                colors: [
                    Color(red: 0.05, green: 0.28, blue: 0.10).opacity(0.7),
                    Color(red: 0.02, green: 0.12, blue: 0.05).opacity(0.4),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 340
            )
            .ignoresSafeArea()

            // Top vignette
            LinearGradient(
                colors: [Color.black.opacity(0.5), Color.clear],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            // Bottom vignette
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.6)],
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Noise texture simulation via subtle dots (optional)
            Canvas { context, size in
                var rng = SystemRandomNumberGenerator()
                for _ in 0..<300 {
                    let x = CGFloat.random(in: 0...size.width, using: &rng)
                    let y = CGFloat.random(in: 0...size.height, using: &rng)
                    let opacity = Double.random(in: 0.01...0.04, using: &rng)
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: 1.5, height: 1.5)),
                        with: .color(.white.opacity(opacity))
                    )
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }
}

// MARK: - Preview
#Preview {
    VoiceAssistantView()
}
