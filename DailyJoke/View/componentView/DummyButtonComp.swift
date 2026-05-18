import SwiftUI

struct DummyButtonComp: View {
    
    let title: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        )
        .frame(height: 60)
    }
}
