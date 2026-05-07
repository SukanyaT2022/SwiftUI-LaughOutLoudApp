import SwiftUI

struct ArrowDownAnimationComp: View {
    @State private var animate = false
    
    var body: some View {
        VStack {
            Image(systemName: "chevron.down.2")
                .font(.system(size: 30, weight: .bold))
                
                // Color animation (bright <-> less bright)
                .foregroundColor(animate ? Color.white : Color.white.opacity(0.4))
                
                // Move up and down slightly
                .offset(y: animate ? 8 : -8)
                
                // Smooth animation
                .animation(
                    .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: animate
                )
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ArrowDownAnimationComp()
}
