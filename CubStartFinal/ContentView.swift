//
//  ContentView.swift
//  CubStartFinal
//
//  Created by Jonathan Dinh on 11/22/23.
//

import SwiftUI

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = true
}

class UserCredentials: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmed_password: String = ""
}

struct FeastLoginView: View {
    // Environment objects for managing user session and credentials
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var userCredentials: UserCredentials

    // State variables to manage user input and view control
    @State private var isSignUp: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    @State private var wrongPassword: Bool = false
    @State private var showSignUpSuccessMessage = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Image at the top of the login view
                Image("Culinary")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 20)
                Spacer()
                
                // Displays error message for incorrect credentials
                if wrongPassword && !isSignUp {
                    Text("Wrong username or password, please try again")
                        .padding()
                        .foregroundColor(.black)
                        .cornerRadius(20)
                }
                
                VStack(spacing: 20) {
                    // Text field for username/email input
                    TextField("Username or Email", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .foregroundStyle(Color.black)
                    
                    // Secure field for password input
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .foregroundStyle(Color.black)
                    
                    // Secure field for confirming password (visible during sign-up)
                    if isSignUp {
                        SecureField("Confirm Password", text: $confirmedPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .foregroundStyle(Color.black)
                    }
                    
                    // Button for sign-in or sign-up action
                    Button(action: signInOrSignUp) {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    // Transition to ProfileView on successful login
                    .fullScreenCover(isPresented: $userSession.isLoggedIn) {
                        ProfileView(username: username)
                    }
                    // Alert for successful sign-up
                    .alert(isPresented: $showSignUpSuccessMessage) {
                        Alert(title: Text("Sign Up Successful"), message: Text("Your account has been created successfully."), dismissButton: .default(Text("OK")))
                    }
                    
                    // Toggle button between Sign In and Sign Up view
                    Button(action: {
                        isSignUp.toggle()
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Text for forgotten password
                Text("Forgot Password?")
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
            }
            .padding()
            .background(Color.pink.opacity(0.2).edgesIgnoringSafeArea(.all))
        }
    }

    // Functions to handle sign-in and sign-up logic
    private func signInOrSignUp() {
        if isSignUp {
            signUp()
        } else {
            signIn()
        }
    }

    private func signIn() {
        // Validate user credentials and update session status
        if UserManager.shared.validateUser(username: username, password: password) {
            userSession.isLoggedIn = true
        } else {
            wrongPassword = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                wrongPassword = false
            }
        }
    }

    private func signUp() {
        // Create a new user account and display success message
        if confirmedPassword == password {
            UserManager.shared.createUser(username: username, password: password)
            showSignUpSuccessMessage = true
            clearInputFields()
        } else {
            // Handle scenario where passwords do not match
        }
    }

    private func clearInputFields() {
        // Clears the input fields post-sign up
        username = ""
        password = ""
        confirmedPassword = ""
        isSignUp = false
    }
}


    



struct FeastLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FeastLoginView()
            .environmentObject(UserSession()) // Providing UserSession environment object for the preview
    }
}


struct ProfileView: View {
    // Environment object to manage user session state
    @EnvironmentObject var userSession: UserSession
    
    // Properties for user profile information
    var username: String
    var userPhoto: String = "userPlaceholder" // Placeholder for user photo

    // States for managing editable profile data and view control
    @State private var editableProfileData = EditableProfileData(age: "", sex: "", country: "")
    @State private var showingEditProfile = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile image
                Image(userPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 20)

                // Username display
                Text(username)
                    .font(.title)
                    .padding(.bottom, 10)

                // Group of text displaying user's editable profile data
                Group {
                    Text("Age: \(editableProfileData.age)")
                    Text("Sex: \(editableProfileData.sex)")
                    Text("Country: \(editableProfileData.country)")
                }
                .font(.body)
                .foregroundColor(.gray)
                
                // Horizontal stack for displaying additional user stats
                HStack {
                    VStack {
                        Text("Recipes Saved")
                            .font(.headline)
                        Text("25")
                            .font(.title2)
                    }
                    Spacer()
                    VStack {
                        Text("Recipes Shared")
                            .font(.headline)
                        Text("15")
                            .font(.title2)
                    }
                }.padding()

                // Button to edit the culinary profile
                Button("Edit Culinary Profile") {
                    showingEditProfile = true // Triggers the sheet to edit profile
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(20)
                .sheet(isPresented: $showingEditProfile) {
                    // Sheet to edit the profile, passing the binding to editable data
                    EditProfileView(profileData: $editableProfileData) { newData in
                        editableProfileData = newData // Updating profile data with new data
                    }
                }

                // Log out button
                Button("Log Out", action: logOut)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                    .padding()
            }
        }
        .padding()
        .background(Color.pink.opacity(0.2).edgesIgnoringSafeArea(.all))
    }

    // Function to handle the log out action
    private func logOut() {
        userSession.isLoggedIn = false // Sets the user session to logged out
    }
}

struct EditableProfileData {
    var age: String
    var sex: String
    var country: String
}

struct EditProfileView: View {
    // Binding to the editable profile data from the parent view
    @Binding var profileData: EditableProfileData

    // Completion handler passed from the parent view for saving changes
    var onSave: (EditableProfileData) -> Void

    // Environment property to manage the presentation mode of this view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Title for the edit profile section
            Text("Personal Information")
                .font(.headline)
                .padding(.top, 20)

            // Text field for editing the age
            TextField("Age", text: $profileData.age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            // Text field for editing the sex
            TextField("Sex", text: $profileData.sex)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            // Text field for editing the country
            TextField("Country", text: $profileData.country)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            // Submit button to save changes and dismiss the view
            Button("Submit") {
                onSave(profileData) // Calls the onSave closure with updated data
                presentationMode.wrappedValue.dismiss() // Dismisses the view
            }
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(20)
            .shadow(radius: 5)

            Spacer() // Pushes all content to the top
        }
        .padding()
        .background(Color.pink.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}






    

