//
//  StudentViewModel.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import Foundation
import Supabase

class StudentViewModel {
    private let client = SupabaseClient(supabaseURL: URL(string: "https://tgodhziiyavtlfztzcpd.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRnb2RoemlpeWF2dGxmenR6Y3BkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5MjY3MjksImV4cCI6MjA1MjUwMjcyOX0.ZQAmsNJCigo75kOt50UZmPyiktQQl4APpBos4CvpXiI")
    @Published var students: [Student] = []
    
    @MainActor
    func fetchStudents() async {
        do {
            let response = try await client.database.from("students").select().execute()
            let students = try JSONDecoder().decode([Student].self, from: response.data)
            self.students = students
        } catch {
            print("Failed to fetch/decode students: \(error)")
        }
    }
}
