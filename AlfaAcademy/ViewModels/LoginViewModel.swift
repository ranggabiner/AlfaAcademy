//
//  LoginViewModel.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation
import Supabase

class LoginViewModel {
    private let client = SupabaseClient(supabaseURL: URL(string: "url")!, supabaseKey: "key")

    private func getEmailByUsername(_ username: String) async throws -> String? {
        let query = client.from("users")
            .select("email")
            .eq("username", value: username)
            .single()
        
        let response: [String: String] = try await query.execute().value
        return response["email"]
    }

    func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                guard let email = try await getEmailByUsername(username) else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])
                }
                
                do {
                    _ = try await client.auth.signIn(email: email, password: password)
                        UserDefaultsHelper.isLoggedIn = true
                        completion(.success(()))
                } catch {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Wrong password"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
