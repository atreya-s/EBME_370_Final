import CoreData
import SwiftUI

class PatientDataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "PatientLogin")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
    }

    // Save a new patient
    func savePatient(username: String, password: String) {
        let context = container.viewContext
        let newPatient = Patients(context: context)
        newPatient.username = username
        newPatient.password = password

        do {
            try context.save()
        } catch {
            print("Failed to save patient: \(error.localizedDescription)")
        }
    }

    // Validate user credentials
    func validateLogin(username: String, password: String) -> Bool {
        let request: NSFetchRequest<Patients> = Patients.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let patients = try container.viewContext.fetch(request)
            return patients.first != nil // Ensure you're checking for a non-nil value
        } catch {
            print("Failed to fetch patients: \(error.localizedDescription)")
            return false
        }
    }

    // Fetch medications for a specific patient
    func fetchMedications(for patient: Patients) -> [Medications] {
        let request: NSFetchRequest<Medications> = Medications.fetchRequest()
        request.predicate = NSPredicate(format: "patient == %@", patient)

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch medications: \(error.localizedDescription)")
            return []
        }
    }
}

