import SwiftUI
struct VoiceControlBarComp: View {
    @Binding var isListening: Bool
    @ObservedObject var speechRecognizer: SpeechRecognizer
    var onSwap: () -> Void = {}
    var onClose: () -> Void = {}

    var body: some View {
        HStack(spacing: 40) {
            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(Color.blue))
            }

            micButton

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(Color(red: 0.2, green: 0.85, blue: 0.75)))
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 40)
    }

    private var micButton: some View {
        Button {
            if speechRecognizer.isRecording {
                speechRecognizer.stopListening()
                isListening = false
            } else {
                speechRecognizer.startListening()
                isListening = true
            }
        } label: {
            ZStack {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .stroke(Color.white.opacity(isListening ? 0.25 - Double(i) * 0.04 : 0.08), lineWidth: 1)
                        .frame(width: 72 + CGFloat(i) * 18, height: 72 + CGFloat(i) * 18)
                        .scaleEffect(isListening ? 1.05 : 1.0)
                        .animation(
                            isListening
                                ? .easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(i) * 0.1)
                                : .default,
                            value: isListening
                        )
                }
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: isListening ? "waveform" : "mic.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
        }
    }
}
