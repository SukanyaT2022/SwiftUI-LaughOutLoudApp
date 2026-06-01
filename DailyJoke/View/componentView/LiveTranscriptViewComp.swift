import SwiftUI
struct LiveTranscriptViewComp: View {
    let fullText: String

    private var primaryLine: String {
        let parts = fullText.split(separator: " ", omittingEmptySubsequences: true)
        guard parts.count > 8 else { return fullText }
        return parts.prefix(8).joined(separator: " ")
    }

    private var secondaryLine: String {
        let parts = fullText.split(separator: " ", omittingEmptySubsequences: true)
        guard parts.count > 8 else { return "" }
        return parts.dropFirst(8).joined(separator: " ")
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(primaryLine)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            if !secondaryLine.isEmpty {
                Text(secondaryLine)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .animation(.easeOut(duration: 0.2), value: fullText)
    }
}
