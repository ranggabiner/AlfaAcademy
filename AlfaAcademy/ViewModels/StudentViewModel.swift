//
//  StudentViewModel.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation
import Supabase

class StudentViewModel {
    private let client = SupabaseClient(supabaseURL: URL(string: "url")!, supabaseKey: "key")
    @Published var students: [Student] = []
    
    @MainActor
    func fetchStudents() async throws {
        do {
            let response = try await client.from("students").select().execute()
            let students = try JSONDecoder().decode([Student].self, from: response.data)
            self.students = students
        } catch {
            print("Failed to fetch/decode students: \(error)")
        }
    }
}
