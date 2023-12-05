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
    @StateObject var favoriteRecipes = FavoriteRecipes(recipes:[])

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Recipe.self, FavoriteRecipes.self])
                .environmentObject(userSession)  // Inject UserSession into FeastLoginView
                .environmentObject(favoriteRecipes)
        }
    }
}
