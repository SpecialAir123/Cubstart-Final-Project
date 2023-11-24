//
//  ContentView.swift
//  CubStartFinal
//
//  Created by Jonathan Dinh on 11/22/23.
//

import SwiftUI

class UserCredentials: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmed_password: String = ""
}


struct FeastLoginView: View {
    @EnvironmentObject var userCredentials: UserCredentials
    @State private var isSignUp: Bool = false
    @State private var isSignIn: Bool = false
    @State private var StoredCredential = [String:String]()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmed_password: String = ""
    @State private var Wrong_password: Bool = false
    @State private var SuccessfullLogin: Bool = false
    @State private var GotoWorld = false
    @State private var SignUpSuccess = false
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                
                Image("Culinary")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 20)
                Spacer()
                if Wrong_password && !isSignUp{
                    Text("Wrong username or password, please try again").padding().foregroundColor(.black)
                        .cornerRadius(20)
                }
                
                VStack(spacing: 20) {
                    TextField("Username or Email", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding().foregroundStyle(Color.black)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding().foregroundStyle(Color.black)
                    
                    if isSignUp {
                        SecureField("Confirm Password",text: $confirmed_password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding().foregroundStyle(Color.black)
                    }
                    
                    
                    Button(action: {
                        isSignIn = true
                        if isSignIn && StoredCredential.isEmpty && !Wrong_password && !isSignUp || !isValidLoggin() {
                            Wrong_password.toggle()
                            isSignIn = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            Wrong_password = false
                        }
                        if isSignIn && isValidLoggin() && !isSignUp && SignUpSuccess{
                            GotoWorld = true
                            
                        }
                        
                        if isSignUp {
                            //Sign up Here is where we store the credential but I don't know how
                            if confirmed_password == password{
                                StoredCredential[username] = password
                                isSignIn = false
                                SignUpSuccess = true
                            }
                        }
                        _ = isSignUp ? "Sign Up" : "Sign In"
                       
                    }) {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                    }.fullScreenCover(isPresented: $GotoWorld) {
                        World()
                    }
                    
                
                    
                    
                    Button(action: {
                        isSignUp.toggle()
                    }) {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("Forgot Password?")
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
            }
            .padding()
            .background(Color.pink
                .opacity(0.2)).foregroundColor(Color.white).edgesIgnoringSafeArea(.all)
        }
    }
        
    private func isValidLoggin() -> Bool{
            return StoredCredential[username] == password
    }
        
        
}
    

struct FeastLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FeastLoginView()
            
    }
}
