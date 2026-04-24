import Foundation
import Combine

class TranscriptStore: ObservableObject {

    struct Entry {
        let text: String
        let source: Source
        let date: Date
    }

    enum Source {
        case voice
        case keyboard
    }

    @Published var entries: [Entry] = []

    private let fileName = "transcript.txt"

    // Add new message
    func add(text: String, source: Source) {
        let entry = Entry(text: text, source: source, date: Date())
        entries.append(entry)
        saveToFile(entry)
    }

    // Save to txt file
    private func saveToFile(_ entry: Entry) {
        let line = "[\(entry.source)] \(entry.text)\n"

        let url = getFileURL()

        if FileManager.default.fileExists(atPath: url.path) {
            if let handle = try? FileHandle(forWritingTo: url) {
                handle.seekToEndOfFile()
                handle.write(Data(line.utf8))
                handle.closeFile()
            }
        } else {
            try? line.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    private func getFileURL() -> URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return doc.appendingPathComponent(fileName)
    }
}
