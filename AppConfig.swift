import Foundation

enum AppConfig {
    
    static var apiBaseURL: String {
        let raw = value(for: "API_BASE_URL")
        // `API_BASE_URL` is stored in xcconfig/Info.plist without `https://` to avoid `//` comment parsing.
        // If it already contains a scheme, keep it as-is.
        if raw.contains("://") { return raw }
        return "https://" + raw
    }
    
    static var appName: String {
        value(for: "APP_NAME")
    }
    
    static var environment: String {
        value(for: "ENVIRONMENT")
    }
    
    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing \(key) in Info.plist")
        }
        return value
    }
}
