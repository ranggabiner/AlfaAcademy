//
//  LoginViewModel.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation
import Supabase

class LoginViewModel {
    private let client = SupabaseClient(supabaseURL: URL(string: "https://tgodhziiyavtlfztzcpd.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRnb2RoemlpeWF2dGxmenR6Y3BkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5MjY3MjksImV4cCI6MjA1MjUwMjcyOX0.ZQAmsNJCigo75kOt50UZmPyiktQQl4APpBos4CvpXiI")
    
    private func getEmailByUsername(_ username: String) async throws -> String? {
        let query = client.database
            .from("users")
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
                
                let response = try await client.auth.signIn(email: email, password: password)
                if response.user != nil {
                    UserDefaultsHelper.isLoggedIn = true
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
