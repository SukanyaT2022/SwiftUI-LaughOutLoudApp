import Foundation
import Security

enum KeychainService {
    enum KeychainError: LocalizedError {
        case invalidValue(String)
        case unexpectedStatus(OSStatus)

        var errorDescription: String? {
            switch self {
            case .invalidValue(let message):
                return message
            case .unexpectedStatus(let status):
                let systemMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
                return "Keychain error (OSStatus: \(status)): \(systemMessage)"
            }
        }
    }

    static func save(service: String, account: String, value: String) throws {
        let data = Data(value.utf8)

        // Ensure we always end up with exactly one item for (service, account).
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(baseQuery as CFDictionary)

        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]
        let updateStatus = SecItemUpdate(baseQuery as CFDictionary, updateAttributes as CFDictionary)
        if updateStatus == errSecSuccess {
            return
        }
        if updateStatus != errSecItemNotFound {
            throw KeychainError.unexpectedStatus(updateStatus)
        }

        var addQuery = baseQuery
        addQuery[kSecValueData as String] = data
        #if (os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)) && !targetEnvironment(macCatalyst)
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        #endif

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    static func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension KeychainService {
    private enum Gemini {
        static let service = "DailyJoke.gemini"
        static let account = "apiKey"
    }

    static func saveGeminiApiKey(_ apiKey: String) throws {
        let trimmed = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw KeychainError.invalidValue("Gemini API key is empty.")
        }
        guard !trimmed.contains("$(") else {
            throw KeychainError.invalidValue("Gemini API key is unresolved. Check your build setting for API_KEY.")
        }
        try save(service: Gemini.service, account: Gemini.account, value: trimmed)
    }

    static func loadGeminiApiKey() -> String? {
        read(service: Gemini.service, account: Gemini.account)
    }
}

