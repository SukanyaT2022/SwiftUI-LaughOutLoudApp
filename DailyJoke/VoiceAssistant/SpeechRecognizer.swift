import Combine
import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject {
    
    @Published var transcribedText: String = ""
    @Published var isRecording = false
    @Published var errorMessage: String?

    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    // MARK: - Permission
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    let speechGranted = (status == .authorized)
                    if !micGranted {
                        self.errorMessage = "Microphone permission denied. Enable it in Settings."
                    } else if !speechGranted {
                        self.errorMessage = "Speech Recognition permission denied. Enable it in Settings."
                    } else {
                        self.errorMessage = nil
                    }
                    completion(micGranted && speechGranted)
                }
            }
        }
    }

    // MARK: - Start Listening
    func startListening() {
        stopListening() // reset any previous task/tap

        transcribedText = ""
        errorMessage = nil

        guard let speechRecognizer, speechRecognizer.isAvailable else {
            errorMessage = "Speech recognizer unavailable."
            return
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Audio session error: \(error.localizedDescription)"
            return
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else {
            errorMessage = "Unable to create recognition request."
            return
        }
        request.shouldReportPartialResults = true

        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)

        task = speechRecognizer.recognitionTask(with: request) { result, error in
            DispatchQueue.main.async {
                if let result {
                    self.transcribedText = result.bestTranscription.formattedString
                }
                if let error {
                    self.errorMessage = error.localizedDescription
                    self.stopListening()
                }
            }
        }

        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            DispatchQueue.main.async { self.isRecording = true }
        } catch {
            errorMessage = "Audio engine failed: \(error.localizedDescription)"
            stopListening()
        }
    }

    // MARK: - Stop Listening
    func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
        DispatchQueue.main.async { self.isRecording = false }

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            // ignore: not critical for UI flow
        }
    }
}
