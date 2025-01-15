//
//  UserDefaultsHelper.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation

enum UserDefaultsHelper {
    static let isLoggedInKey = "isLoggedIn"
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
        }
    }
    
    static func logout() {
        isLoggedIn = false
    }
}
