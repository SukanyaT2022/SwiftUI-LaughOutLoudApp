import SwiftUI
struct VoiceAssistantTopBarComp: View {
    var onBack: () -> Void = {}
    var onNotifications: () -> Void = {}

    var body: some View {
        HStack {
            circleButton(systemName: "chevron.left", action: onBack)
            Spacer()
            Text("Get Chat")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.12)))
            Spacer()
            circleButton(systemName: "bell", action: onNotifications)
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
    }

    private func circleButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.white.opacity(0.1)))
        }
    }
}
