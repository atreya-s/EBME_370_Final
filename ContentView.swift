import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false

    var body: some View {
        NavigationView {  // Wrap everything in NavigationView for navigation to work
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

                    NavigationLink(destination: HomeScreen(), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }

    func authenticateUser(username: String, password: String) {
        // Add authentication logic here
        // On successful authentication, set showingLoginScreen to true
        if username == "testUser" && password == "1234" {  // Example check
            showingLoginScreen = true
        } else {
            // Handle invalid credentials (for example, show error message)
        }
    }
}

struct HomeScreen: View {
    @Environment(\.presentationMode) var presentationMode  // For handling back button

    var body: some View {
        VStack {
            // Back Button to return to ContentView (Login Screen)
            HStack {
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

            // Home screen content here (e.g., pill reminder info)
            Text("Home Screen")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}
