//
//  ButtonComp.swift
//  DailyJoke
//
//  Created by TS2 on 5/7/26.
//

import SwiftUI

struct ButtonComp: View {
    let title: String
        let systemImage: String
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(systemName: systemImage)
                        .font(.system(size: 20, weight: .medium))
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .background(Color(.systemBackground)) // Adapts to Dark Mode
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            }
            .buttonStyle(PlainButtonStyle()) // Prevents default blue tinting
        }
}

#Preview {
    ButtonComp(title: "Tell me a joke", systemImage: "face.smiling") {
        // preview action
    }
}
