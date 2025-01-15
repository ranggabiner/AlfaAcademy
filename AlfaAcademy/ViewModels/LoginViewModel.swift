//
//  LoginViewModel.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation

class LoginViewModel {
    func login(username: String, password: String) -> Bool {
        let credentials = LoginCredentials(username: username, password: password)
        let isValid = LoginValidation.validate(credentials: credentials)
        if isValid {
            UserDefaultsHelper.isLoggedIn = true
        }
        return isValid
    }
}
