import SwiftUI

@main
struct Pill_ReminderApp: App {
    
    init() {
        // Add test cases directly here
        addTestUsers()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // Your starting view
        }
    }
    
    private func addTestUsers() {
        // Test users to add
        let testUsers = [
            ("testUser1", "password123"),
            ("johnDoe", "pass456"),
            ("janeDoe", "secure789"),
            ("admin", "admin123")
        ]

        // Save each test user to the database
        for (username, password) in testUsers {
            dataController.savePatient(username: username, password: password)
        }
        print("Test users added successfully!")
    }
}

