import SwiftUI

@main
struct Pill_ReminderApp: App {
    @StateObject private var dataController = PatientDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dataController)  // Your starting view
        }
    }

}

