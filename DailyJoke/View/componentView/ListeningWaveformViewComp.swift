import SwiftUI
struct ListeningWaveformViewComp: View {
    var isActive: Bool
    var audioLevel: CGFloat  // 0...1, from SpeechRecognizer (Step 8)

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let midY = size.height / 2
                let colors: [Color] = [
                    Color.cyan,
                    Color(red: 0.6, green: 0.5, blue: 1),
                    Color(red: 1, green: 0.3, blue: 0.8)
                ]
                for (i, color) in colors.enumerated() {
                    var path = Path()
                    let amp = (isActive ? 18 + audioLevel * 40 : 8) * (1 - CGFloat(i) * 0.15)
                    let freq = 1.2 + Double(i) * 0.3
                    path.move(to: CGPoint(x: 0, y: midY))
                    for x in stride(from: 0, through: size.width, by: 4) {
                        let phase = t * 2 + Double(x) / 80 * freq + Double(i)
                        let y = midY + sin(phase) * amp
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    context.stroke(
                        path,
                        with: .color(color.opacity(0.85)),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                }
            }
        }
        .frame(height: 160)
        .padding(.horizontal, 24)
    }
}
