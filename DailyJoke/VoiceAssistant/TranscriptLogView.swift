import SwiftUI
import Combine
struct TranscriptLogView: View {

    @ObservedObject var store: TranscriptStore

    var body: some View {
        NavigationView {
            List(store.entries.indices, id: \.self) { index in
                let entry = store.entries[index]

                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.text)
                        .font(.body)

                    Text(entry.source == .voice ? "Voice" : "Keyboard")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Transcript History")
        }
    }
}
