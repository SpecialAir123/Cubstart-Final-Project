//
//  CubStartFinalApp.swift
//  CubStartFinal
//
//  Created by Jonathan Dinh on 11/22/23.
//

import SwiftUI
import SwiftData

@main
struct YourAppName: App {
    @StateObject var userSession = UserSession()  // Create an instance of UserSession

    var body: some Scene {
        WindowGroup {
            FeastLoginView()
                .environmentObject(userSession)  // Inject UserSession into FeastLoginView
        }
    }
}
