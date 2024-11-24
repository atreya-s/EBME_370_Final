import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false
    @State private var errorMessage = ""

    @Environment(\.managedObjectContext) var moc  // Core Data context
    @StateObject private var dataController = PatientDataController()  // Core Data controller

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
                        createTestAccount()
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

    // Create a test user
    func createTestAccount() {
        dataController.savePatient(username: "testUser", password: "1234")
        errorMessage = "Test account created. Username: testUser, Password: 1234"
    }
}

// HomeScreen (Post Login)
import SwiftUI

struct HomeScreen: View {
    @Environment(\.presentationMode) var presentationMode  // For back button
    var username: String  // Passed from login

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
            Spacer()

            // Welcome and Pill Reminder Interface
            VStack(alignment: .leading) {
                Text("Good Morning")
                    .font(.title2)
                    .foregroundColor(.white)
                Text(username)  // Display the username dynamically
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer().frame(height: 20)
                
                // Pill Reminder Example
                HStack {
                    Text("8:00 AM")
                        .font(.headline)
                        .foregroundColor(.teal)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Acetaminophen")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("1 Pill Before Food")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Spacer()
            }
            .padding()

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    ContentView()
}
