//
//  LullabyRecipeApp.swift
//  WatchLullabyRecipe WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/07/10.
//

import SwiftUI

@main
struct LullabyRecipeApp: App {
    @State private var selection = 0
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            
            NavigationView {
                
                ContentView()
                
            }
            
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
