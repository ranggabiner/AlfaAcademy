//
//  LoginCredentials.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation

struct LoginCredentials {
    let username: String
    let password: String
}

struct LoginValidation {
    static func validate(credentials: LoginCredentials) -> Bool {
        return credentials.username == "alfagift-admin" && credentials.password == "asdf"
    }
}
