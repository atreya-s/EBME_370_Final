import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dataController: PatientDataController
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false
    @State private var errorMessage = ""
    @Environment(\.managedObjectContext) var moc  // Core Data context// Core Data controller

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Text("Welcome")
                        .font(.largeTitle)
                        .foregroundColor(.teal)

                    Text("Please enter your credentials")
                        .font(.headline)
                        .foregroundColor(.teal)

                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button(action: {
                        authenticateUser(username: username, password: password)
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .cornerRadius(10)
                    }
                    .padding()

                    // NavigationLink to HomeScreen
                    NavigationLink(destination: HomeScreen(username: username), isActive: $showingLoginScreen) {
                        EmptyView()
                    }

                    Spacer()

                    Button(action: {
                        addTestUsers()
                    }) {
                        Text("Create Test Account")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
        }
    }

    // Authenticate using Core Data
    func authenticateUser(username: String, password: String) {
        if dataController.validateLogin(username: username, password: password) {
            showingLoginScreen = true
        } else {
            errorMessage = "Invalid username or password"
            wrongUsername = 2
            wrongPassword = 2
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
    }
}

// HomeScreen (Post Login)
struct HomeScreen: View {
    @EnvironmentObject var dataController: PatientDataController
    @Environment(\.presentationMode) var presentationMode  // For back button
    var username: String  // Passed from login
    @State private var dailySchedule: [(time: String, medication: String, instructions: String)] = []
    @State private var showingAddMedication = false  // To show AddMedicationView
    
    private let currentDay: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"  // Get the full name of the day
        return dateFormatter.string(from: Date())
    }()

    var body: some View {
        VStack {
            HStack {
                // Back Button to return to ContentView (Login Screen)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Dismiss HomeScreen
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                }
                Spacer()
            }

            // Header
            VStack(alignment: .leading) {
                Text("Good Morning, \(username)")
                    .font(.largeTitle)
                    .foregroundColor(.teal)
                Text("Today is \(currentDay)")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)

            // Medications for Today
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Medications")
                    .font(.headline)
                    .foregroundColor(.teal)
                    .padding(.bottom, 10)

                if dailySchedule.isEmpty {
                    Text("No medications scheduled for today.")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    ForEach(dailySchedule, id: \.time) { medication in
                        HStack {
                            Text(medication.time)
                                .font(.subheadline)
                                .foregroundColor(.teal)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(medication.medication)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(medication.instructions)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()

            Spacer()

            // Button to navigate to WeeklyCalendarView
            NavigationLink(destination: WeeklyCalendarView(username: username)) {
                Text("View Weekly Medication Calendar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .padding()

            // Add Medication Button
            Button(action: {
                showingAddMedication.toggle()
            }) {
                Text("Add Medication")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView(username: username)  // Pass the username directly
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            loadMedicationsForToday()
        }
    }

    // Load example medications for the current day
    private func loadMedicationsForToday() {
        let weeklySchedule: [String: [(time: String, medication: String, instructions: String)]] = [
            "Monday": [
                (time: "8:00 AM", medication: "Acetaminophen", instructions: "1 Pill Before Food"),
                (time: "12:00 PM", medication: "Ibuprofen", instructions: "1 Pill After Lunch")
            ],
            "Tuesday": [
                (time: "9:00 AM", medication: "Vitamin D", instructions: "1 Tablet With Water"),
                (time: "6:00 PM", medication: "Omega 3", instructions: "2 Capsules After Dinner")
            ],
            "Wednesday": [
                (time: "7:30 AM", medication: "Paracetamol", instructions: "1 Pill Before Breakfast"),
                (time: "8:00 PM", medication: "Calcium", instructions: "1 Tablet Before Bed")
            ],
            "Thursday": [
                (time: "9:00 AM", medication: "Probiotic", instructions: "1 Capsule With Breakfast")
            ],
            "Friday": [
                (time: "6:30 AM", medication: "Vitamin C", instructions: "1 Tablet Before Meal")
            ],
            "Saturday": [
                (time: "7:00 PM", medication: "Zinc", instructions: "1 Tablet With Dinner")
            ],
            "Sunday": [
                (time: "8:00 AM", medication: "Magnesium", instructions: "1 Tablet After Breakfast"),
                (time: "9:00 PM", medication: "Melatonin", instructions: "1 Tablet Before Sleep")
            ]
        ]
        dailySchedule = weeklySchedule[currentDay] ?? []
    }
}


import SwiftUI
import CoreData

// Unique, identifiable medication entry struct
struct MedicationEntry: Identifiable {
    let id: UUID  // Unique identifier for each entry
    let medicationObjectID: NSManagedObjectID  // Original Core Data object ID
    var time: String
    let medication: String
    let instructions: String
}

struct WeeklyCalendarView: View {
    @EnvironmentObject var dataController: PatientDataController  // Core Data access
    var username: String  // Passed from the previous view
    
    @State private var weeklySchedule: [String: [MedicationEntry]] = [:]
    @State private var editingEntryID: UUID? = nil
    @State private var newTime: String = ""
    
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(daysOfWeek, id: \.self) { day in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(day)
                            .font(.headline)
                            .foregroundColor(.teal)
                            .padding(.bottom, 5)
                        
                        if let medications = weeklySchedule[day], !medications.isEmpty {
                            ForEach(medications) { medication in
                                HStack {
                                    VStack(alignment: .leading) {
                                        if medication.id == editingEntryID {
                                            // Editing mode
                                            TextField(medication.time, text: $newTime)
                                                .font(.subheadline)
                                                .foregroundColor(.teal)
                                            Text(medication.medication)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            Text(medication.instructions)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        } else {
                                            // Display mode
                                            Text(medication.time)
                                                .font(.subheadline)
                                                .foregroundColor(.teal)
                                            Text(medication.medication)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            Text(medication.instructions)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if medication.id == editingEntryID {
                                        // Save button when editing
                                        Button(action: {
                                            updateMedicationTime(for: medication)
                                            editingEntryID = nil
                                        }) {
                                            Text("Save")
                                                .foregroundColor(.green)
                                        }
                                    } else {
                                        // Edit button
                                        Button(action: {
                                            editingEntryID = medication.id
                                            newTime = medication.time
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    
                                    // Delete button
                                    Button(action: {
                                        removeMedication(withID: medication.id)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                        } else {
                            Text("No medications scheduled.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 15)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            fetchMedicationsForUsername()
        }
    }
    
    // Fetch medications for the specific username
    private func fetchMedicationsForUsername() {
        let context = dataController.container.viewContext
        let request: NSFetchRequest<Medications> = Medications.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let medications = try context.fetch(request)
            populateWeeklySchedule(from: medications)
        } catch {
            print("Failed to fetch medications: \(error.localizedDescription)")
        }
    }
    
    // Generate evenly distributed dose times throughout the day
    private func generateDoseTimes(dosesPerDay: Int) -> [String] {
        let startHour = 8   // Start at 8:00 AM
        let endHour = 20    // End at 8:00 PM
        
        guard dosesPerDay > 0 else { return [] }
        
        var times: [String] = []
        
        // Calculate time interval between doses
        let totalMinuteSpan = (endHour - startHour) * 60
        let minutesBetweenDoses = totalMinuteSpan / max(1, dosesPerDay - 1)
        
        for i in 0..<dosesPerDay {
            // Calculate exact minutes from start
            let totalMinutesFromStart = (startHour * 60) + (i * minutesBetweenDoses)
            let hour = totalMinutesFromStart / 60
            let minute = totalMinutesFromStart % 60
            
            times.append(formatTime(hour: hour, minute: minute))
        }
        
        return times
    }
    
    // Populate weekly schedule with medication entries
    private func populateWeeklySchedule(from medications: [Medications]) {
        var schedule: [String: [MedicationEntry]] = [:]
        
        for medication in medications {
            guard let selectedDays = medication.selectedDays as? [String],
                  let medicationName = medication.medicationName,
                  let notes = medication.notes else { continue }
            
            let times = generateDoseTimes(dosesPerDay: Int(medication.dosesPerDay))
            
            for day in selectedDays {
                let entries = times.map { time in
                    MedicationEntry(
                        id: UUID(),
                        medicationObjectID: medication.objectID,
                        time: time,
                        medication: medicationName,
                        instructions: notes
                    )
                }
                
                schedule[day, default: []].append(contentsOf: entries)
            }
        }
        
        weeklySchedule = schedule
    }
    
    // Format time to a readable string
    private func formatTime(hour: Int, minute: Int = 0) -> String {
        if let time = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: time)
        }
        return "Invalid Time"  // Fallback in case of failure
    }
    
    // Update medication time for a specific entry
    private func updateMedicationTime(for medication: MedicationEntry) {
        for (day, medications) in weeklySchedule {
            if let index = medications.firstIndex(where: { $0.id == medication.id }) {
                weeklySchedule[day]?[index].time = newTime
                break
            }
        }
        
        // Optionally, you might want to save this change to Core Data
        saveTimeChange(for: medication)
    }
    
    // Save time change to Core Data
    private func saveTimeChange(for medication: MedicationEntry) {
        let context = dataController.container.viewContext
        
        do {
            // Fetch the original medication object
            if let medicationObject = try context.existingObject(with: medication.medicationObjectID) as? Medications {
                // Here you might want to add logic to update the time in the Core Data object
                // This depends on how you're storing times in your Core Data model
                try context.save()
            }
        } catch {
            print("Failed to save time change: \(error.localizedDescription)")
        }
    }
    
    // Remove a medication entry
    private func removeMedication(withID id: UUID) {
        let context = dataController.container.viewContext
        
        do {
            // Find the entry with the given UUID
            for (day, medications) in weeklySchedule {
                if let index = medications.firstIndex(where: { $0.id == id }) {
                    let medication = weeklySchedule[day]?[index]
                    
                    // Use the original Core Data object ID to delete
                    if let objectID = medication?.medicationObjectID,
                       let medicationObject = try context.existingObject(with: objectID) as? Medications {
                        context.delete(medicationObject)
                        try context.save()
                        fetchMedicationsForUsername()
                        break
                    }
                }
            }
        } catch {
            print("Failed to delete medication: \(error.localizedDescription)")
        }
    }
}

import SwiftUI

struct AddMedicationView: View {
    @EnvironmentObject var dataController: PatientDataController
    @Environment(\.presentationMode) var presentationMode  // To dismiss the view
    var username: String  // Pass the username as a parameter

    @State private var medicationName = ""
    @State private var selectedDays: Set<String> = []  // To hold selected days
    @State private var dosesPerDay = 1
    @State private var contraindications = ""
    @State private var notes = ""
    @State private var showAlert = false  // To trigger the warning alert
    @State private var alertMessage = ""
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationView {
            Form {
                // Medication Name Field
                Section(header: Text("Medication Name")) {
                    TextField("Enter Medication Name", text: $medicationName)
                }

                // Select Days of the Week
                Section(header: Text("Select Days to Take")) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        HStack {
                            Text(day)
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                    }
                }

                // Doses Per Day
                Section(header: Text("Doses Per Day")) {
                    Stepper(value: $dosesPerDay, in: 1...5) {
                        Text("\(dosesPerDay) time(s) per day")
                    }
                }

                // Contraindications
                Section(header: Text("Contraindications (if any)")) {
                    TextField("Enter contraindications", text: $contraindications)
                }

                // Notes Field
                Section(header: Text("Notes")) {
                    TextField("Enter additional notes (e.g., dosage instructions)", text: $notes)
                }
            }
            .navigationBarTitle("Add Medication")
            .navigationBarItems(trailing: Button("Save") {
                // Check CSV for the medication before saving
                checkMedicationInCSV { isInactivated, medicationName in
                    if isInactivated {
                        // Show alert if inactivation date is not empty
                        alertMessage = "The medication \(medicationName) has an inactivation date. Do you still want to add it?"
                        showAlert = true
                    } else {
                        // Proceed to save if no issue
                        saveMedication()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Add Anyway")) {
                    saveMedication()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }

    // Function to check if the medication is inactivated
    private func checkMedicationInCSV(completion: @escaping (Bool, String) -> Void) {
        // Set the path to the CSV file in the app's bundle
        if let path = Bundle.main.path(forResource: "medications", ofType: "csv") {
            print("CSV file found at path: \(path)")  // Debugging the file path
            
            do {
                // Read the content of the CSV file
                let content = try String(contentsOfFile: path, encoding: .utf8)
                let rows = content.split(separator: "\n")
                print("CSV file content:\n\(content)")  // Print the entire content of the file for debugging

                // Extract the header row
                let headerRow = rows.first?.split(separator: ",")
                guard let header = headerRow else {
                    print("Error: No header row found!")  // Debugging missing header row
                    completion(false, medicationName)
                    return
                }
                print("Header row: \(header)")  // Print the header for debugging
                
                // Find the indices of the "Proprietary Name" and "Inactivation Date" columns
                guard let proprietaryNameIndex = header.firstIndex(of: "Proprietary Name"),
                      let inactivationDateIndex = header.firstIndex(of: "Inactivation Date") else {
                    print("Error: Could not find required columns!")  // Debugging missing columns
                    completion(false, medicationName)
                    return
                }
                print("Proprietary Name column index: \(proprietaryNameIndex)")  // Debugging column index
                print("Inactivation Date column index: \(inactivationDateIndex)")  // Debugging column index
                
                // Now process the rest of the rows
                for row in rows.dropFirst() { // Skip the header row
                    let columns = row.split(separator: ",")
                    print("Processing row: \(columns)")  // Debugging each row being processed
                    
                    // Check if the "Proprietary Name" column matches the medication name
                    if columns.count > proprietaryNameIndex, columns[proprietaryNameIndex] == medicationName {
                        print("Found matching medication: \(medicationName)")  // Debugging match

                        // Check if the "Inactivation Date" column is empty
                        if columns.count > inactivationDateIndex, columns[inactivationDateIndex].isEmpty {
                            print("Inactivation Date is empty. Medication is still active.")  // Debugging empty inactivation date
                            completion(false, medicationName)  // Medication is still active
                        } else {
                            print("Inactivation Date is not empty. Medication is inactivated.")  // Debugging non-empty inactivation date
                            completion(true, medicationName)  // Medication is inactivated
                        }
                        return
                    }
                }
                
                // If medication not found in CSV
                print("Medication \(medicationName) not found in CSV.")  // Debugging medication not found
                completion(false, medicationName)
                
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")  // Debugging error reading CSV
                completion(false, medicationName)
            }
        } else {
            print("CSV file not found!")  // Debugging file not found
            completion(false, medicationName)
        }
    }

    private func saveMedication() {
        let context = dataController.container.viewContext
        let newMedication = Medications(context: context)
        newMedication.medicationName = medicationName
        newMedication.selectedDays = Array(selectedDays) as NSObject  // Save as transformable
        newMedication.dosesPerDay = Int16(dosesPerDay)
        newMedication.contraindications = contraindications
        newMedication.notes = notes
        newMedication.username = username  // Save the username attribute

        do {
            try context.save()
        } catch {
            print("Failed to save medication: \(error.localizedDescription)")
        }
    }
}





#Preview {
    let dataController = PatientDataController()
    ContentView().environmentObject(dataController)
}
