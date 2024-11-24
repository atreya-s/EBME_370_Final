import SwiftUI

import SwiftUI

@main
struct PatientLoginApp: App {
    @StateObject private var dataController = PatientDataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)  // Pass Core Data context
        }
    }
}

