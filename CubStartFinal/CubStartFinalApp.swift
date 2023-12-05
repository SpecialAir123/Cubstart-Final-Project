//
//  CubStartFinalApp.swift
//  CubStartFinal
//
//  Created by Jonathan Dinh on 11/22/23.
//

import SwiftUI
import SwiftData

@main
struct CulinaryConnect: App {
    @StateObject var userSession = UserSession()  // Create an instance of UserSession
    @StateObject var favoriteRecipes = FavoriteRecipes()

    var body: some Scene {
        WindowGroup {
            FeastLoginView()
                .environmentObject(userSession)  // Inject UserSession into FeastLoginView
                .environmentObject(favoriteRecipes)
        }
    }
}
