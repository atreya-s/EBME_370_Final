import SwiftUI


struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false

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
                    NavigationLink(destination: HomeScreen(), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }
    
    // Mock authentication function
    func authenticateUser(username: String, password: String) {
        // Add your real authentication logic here
        if username == "testUser" && password == "1234" {  // Example condition
            showingLoginScreen = true
        } else {
            wrongUsername = 2
            wrongPassword = 2
        }
    }
}

// HomeScreen (Post Login)
struct HomeScreen: View {
    @Environment(\.presentationMode) var presentationMode  // For back button

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
                Text("Gracy")  // Replace with dynamic username if needed
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
                        Text("1 Pill  Before Food")
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
