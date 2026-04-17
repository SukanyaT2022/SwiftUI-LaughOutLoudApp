//
//  ConfigManager.swift
//  DailyJoke
//
//  Created by TS2 on 3/24/26.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI
class ConfigManager: ObservableObject {
 
    
    private let db = Firestore.firestore()
    
    func fetchGeminiKey() {
        db.collection("configKey")
            .document("configKeyID")
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching config: \(error)")
                    return
                }
                
                if let data = snapshot?.data(),
                   let key = data["GeminiKey"] as? String {
                    DispatchQueue.main.async {
                        do  {
                            try KeychainService.save(service: Gemini.service, account: Gemini.account, value: key)
                        }
                catch {
                            print("Failed to save to keychain: \(error)")
                        }
                    }
                }
            }
    }
}
